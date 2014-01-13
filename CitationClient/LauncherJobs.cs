using System;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices.ComTypes;
using System.Threading;
using System.Windows.Forms;
using System.Xml;
using System.Xml.Linq;
using CitationClient.Properties;
using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
using Microsoft.Win32;

namespace CitationClient
{
    public static class LauncherJobs
    {
        #region Static Fields

        public static string KeyName;

        #endregion

        #region Methods

        public static bool IsFirstRun()
        {
            RegistryKey appKey = Registry.CurrentUser.OpenSubKey(KeyName) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);

            object val = appKey.GetValue("FirstRun");
            appKey.Close();
            if (val != null && val.ToString() == "0")
                return false;

            return true;
        }

        public static void SetFirstRun(bool firstRun)
        {
            RegistryKey appKey = Registry.CurrentUser.OpenSubKey(KeyName, true) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            appKey.SetValue("FirstRun", firstRun ? 1 : 0, RegistryValueKind.DWord);
            appKey.Close();
        }

        public static void SaveStringSetting(string keyName, string value)
        {
            RegistryKey key = Registry.CurrentUser.OpenSubKey(KeyName, true) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            key.SetValue(keyName, value);
            key.Close();
        }

        public static string GetStringSetting(string keyName)
        {
            RegistryKey key = Registry.CurrentUser.OpenSubKey(KeyName);
            if (key == null)
                return "";

            object val = key.GetValue(keyName);
            key.Close();
            return val != null ? val.ToString() : "";
        }

        public static void CreateShortcuts()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            CreateShortcut(Application.ProductName, Assembly.GetExecutingAssembly().Location,
                           Application.ProductName + " Start Link",
                           "/update", Environment.GetFolderPath(Environment.SpecialFolder.Startup));

            string programFolder = Environment.GetFolderPath(Environment.SpecialFolder.Programs) + "\\" +
                                   GetPublisher();

            CreateShortcut("Login", path + "\\files\\login.exe",
                           Application.ProductName + " Login Start Link", "", programFolder);

            CreateShortcut("Restart Citation Server", path + "\\files\\restart.exe",
                           "Restart Citation Server", "", programFolder);
        }

        public static string GetPublisher()
        {
            XDocument xDocument;
            using (
                var memoryStream = new MemoryStream(AppDomain.CurrentDomain.ActivationContext.DeploymentManifestBytes))
            using (var xmlTextReader = new XmlTextReader(memoryStream))
            {
                xDocument = XDocument.Load(xmlTextReader);
            }
            XElement description = xDocument.Root.Elements().First(e => e.Name.LocalName == "description");
            XAttribute publisher = description.Attributes().First(a => a.Name.LocalName == "publisher");
            return publisher.Value;
        }

        public static bool PostSetupJobs()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string content = Resources.postinstall;
            content = content.Replace("%~1", path);
            string tempFile = Path.GetTempFileName() + ".bat";
            File.WriteAllText(tempFile, content);
            if (File.Exists(tempFile))
            {
                var process = new Process();
                if (Environment.OSVersion.Version.Major >= 6)
                    process.StartInfo.Verb = "runas"; // This through exception on XP so we check the OS
                process.StartInfo.FileName = tempFile;
                process.StartInfo.WorkingDirectory = path;
                process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

                try
                {
                    process.Start();
                    process.WaitForExit();
                }
                catch (Exception e) // usually will trigger the catch if the user response with NO in the UAC message
                {
                    if (MessageBox.Show("You should press Yes to proceed with this installation, try again?",
                                        "Attention",
                                        MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                    {
                        return PostSetupJobs();
                    }
                    else
                    {
                        return false;
                    }
                }


                File.Delete(tempFile);

                process = new Process
                    {
                        StartInfo =
                            {
                                FileName = path + "\\files\\login.exe",
                                WorkingDirectory = path + "\\files",
                                WindowStyle = ProcessWindowStyle.Normal
                            }
                    };
                process.Start();

                return true;
            }
            return false;
        }

        public static bool Update()
        {
            var updater = new CustomInstaller();
#if DEBUG
            updater.CheckForUpdate("http://sameer-hpc/citation/AllSearch52.application");
#else
            Assembly assembly = Assembly.GetExecutingAssembly();
            object[] attribs = assembly.GetCustomAttributes(false);
            object attrib = attribs.FirstOrDefault(a => a.ToString() == "CitationClient.AssemblyPublishUrlAttribute");
            if (attrib != null)
            {
                var att = attrib as AssemblyPublishUrlAttribute;
                updater.CheckForUpdate(att.PublishUrl);
            }
#endif
            while (updater.NoError && updater.Working)
            {
                Application.DoEvents();
                Thread.Sleep(100);
            }

            if (!updater.Working)
            {
                if (updater.Version > Assembly.GetExecutingAssembly().GetName().Version)
                {
                    KillRuningProcess("citationServer");// check and kill citationServer.exe if running 
                    KillRuningProcess("login");// check and kill login.exe if running 

                    bool updated = updater.Update();
                    while (updater.NoError && updater.Working)
                    {
                        Application.DoEvents();
                        Thread.Sleep(100);
                    }


                    // Uninstalling and re-installing the application will request to run the batch file again so I've commented it.
                    //CustomUninstaller.Uninstall(Properties.Settings.Default.PublicKeyToken);

                    return true;
                }
            }
            return false;
        }

        public static void SaveInformation()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string token = CustomUninstaller.GetPublicKeyToken();
            string keyPath = "";
            string uninstallString = CustomUninstaller.GetUninstallString(token, out keyPath);
            SaveStringSetting("PublicKeyToken", token);
            SaveStringSetting("UninstallString", uninstallString);
            SaveStringSetting("KeyPath", keyPath);
            SaveStringSetting("Publisher", GetPublisher());
            SaveStringSetting("Path", path); // Save the program path in the registry
            SaveStringSetting("Product", Application.ProductName); // Save the program path in the registry
            ChangeUninstallKey(keyPath, Assembly.GetExecutingAssembly().Location + " /uninstall");
        }

        public static void ChangeUninstallKey(string keyPath, string path)
        {
            RegistryKey uninstallKey =
                Registry.CurrentUser.OpenSubKey(keyPath, true);

            if (uninstallKey != null)
            {
                uninstallKey.SetValue("UninstallString", path);
                uninstallKey.Close();
            }
        }

        public static void Uninstall()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location).ToLower();
            var tempPath = Path.GetTempPath();

            File.Copy(path + "\\files\\uninstaller.exe", tempPath + "\\uninstaller.exe", true);
            var process = new Process
            {
                StartInfo =
                {
                    FileName = tempPath + "\\uninstaller.exe",
                    WindowStyle = ProcessWindowStyle.Normal,
                    Arguments = "\"" + KeyName + "\""
                }
            };
            if (Environment.OSVersion.Version.Major >= 6)
                process.StartInfo.Verb = "runas"; // This through exception on XP so we check the OS
            process.Start();
        }



        public static void KillRuningProcess(string processName)
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location).ToLower();
            Process[] serverInstances = Process.GetProcessesByName(processName);
            foreach (Process serverInstance in serverInstances)
            {
                //if (serverInstance.MainModule == null || serverInstance.MainModule.FileName.ToLower().Contains(path))
                    serverInstance.Kill();
            }
            // *****
        }

        public static bool InstallFireFox()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            try
            {
                ExtractZipFile(path + "\\files\\FirefoxPortable.zip", "", path + "\\files\\FirefoxPortable");

                return true;
            }
            catch (Exception e)
            {
                return false;
            }
        }

        private static void ExtractZipFile(string archiveFilenameIn, string password, string outFolder)
        {
            ZipFile zipFile = null;
            try
            {
                FileStream fileStream = File.OpenRead(archiveFilenameIn);
                zipFile = new ZipFile(fileStream);
                if (!String.IsNullOrEmpty(password))
                {
                    zipFile.Password = password; // AES encrypted entries are handled automatically
                }
                foreach (ZipEntry zipEntry in zipFile)
                {
                    if (!zipEntry.IsFile)
                    {
                        continue; // Ignore directories
                    }
                    String entryFileName = zipEntry.Name;
                    // to remove the folder from the entry:- entryFileName = Path.GetFileName(entryFileName);
                    // Optionally match entrynames against a selection list here to skip as desired.
                    // The unpacked length is available in the zipEntry.Size property.

                    var buffer = new byte[4096]; // 4K is optimum
                    Stream zipStream = zipFile.GetInputStream(zipEntry);

                    // Manipulate the output filename here as desired.
                    String fullZipToPath = Path.Combine(outFolder, entryFileName);
                    string directoryName = Path.GetDirectoryName(fullZipToPath);
                    if (directoryName.Length > 0)
                        Directory.CreateDirectory(directoryName);

                    // Unzip file in buffered chunks. This is just as fast as unpacking to a buffer the full size
                    // of the file, but does not waste memory.
                    // The "using" will close the stream even if an exception occurs.
                    using (FileStream streamWriter = File.Create(fullZipToPath))
                    {
                        StreamUtils.Copy(zipStream, streamWriter, buffer);
                    }
                }
            }
            finally
            {
                if (zipFile != null)
                {
                    zipFile.IsStreamOwner = true; // Makes close also shut the underlying stream
                    zipFile.Close(); // Ensure we release resources
                }
            }
        }
        public static void CopyOldFiles(string newprogramLocation)
        {
            string path = GetStringSetting("Path");
            if (path != "")
            {
                if (File.Exists(path + "\\key.txt"))
                    File.Copy(path + "\\key.txt", newprogramLocation + "\\key.txt");

                if (File.Exists(path + "\\bid.txt"))
                    File.Copy(path + "\\bid.txt", newprogramLocation + "\\bid.txt");
            }
        }

        private static void CreateShortcut(string linkName, string linkPath, string linkDescription,
                                           string linkArguments, string shorcutLocation)
        {
            var link = (IShellLink) new ShellLink();

            // setup shortcut information
            link.SetDescription(linkDescription);
            link.SetPath(linkPath);
            link.SetArguments(linkArguments);

            // save it
            var file = (IPersistFile) link;
            string startupPath = shorcutLocation;
            string shortcut = Path.Combine(startupPath, linkName + ".lnk");
            if (File.Exists(shortcut))
                File.Delete(shortcut);
            file.Save(shortcut, false);
        }

        public static string GetAssemblyAttribute<T>(Func<T, string> value)
            where T : Attribute
        {
            var attribute = (T) Attribute.GetCustomAttribute(Assembly.GetExecutingAssembly(), typeof (T));
            return value.Invoke(attribute);
        }

        #endregion
    }
}