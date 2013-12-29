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
            RegistryKey appKey = Registry.CurrentUser.OpenSubKey(KeyName, true) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            appKey.SetValue(keyName, value);
            appKey.Close();
        }

        public static string GetStringSetting(string keyName)
        {
            RegistryKey appKey = Registry.CurrentUser.OpenSubKey(KeyName) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            object val = appKey.GetValue(keyName);
            appKey.Close();
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
                updater.CheckForUpdate("http://sameer-hpc/citation/CitationClient.application");
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
                    KillServerProcess();
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
            string uninstallString = GetStringSetting("UninstallString");

            KillServerProcess();
            CustomUninstaller.Uninstall(uninstallString);

            string link = Environment.GetFolderPath(Environment.SpecialFolder.Startup) + "\\" +
                          Application.ProductName + ".lnk";

            if (File.Exists(link))
                File.Delete(link);


            string programFolder = Environment.GetFolderPath(Environment.SpecialFolder.Programs) + "\\" +
                                   GetStringSetting("Publisher");

            if (Directory.Exists(programFolder))
                Directory.Delete(programFolder, true);
            var key = Registry.CurrentUser.OpenSubKey(KeyName);
            if (key != null)
            {
                key.Close();
                Registry.CurrentUser.DeleteSubKeyTree(KeyName);
            }
            key = Registry.CurrentUser.OpenSubKey(@"Software\Citation\API");
            if (key != null)
            {
                key.Close();
                Registry.CurrentUser.DeleteSubKeyTree(@"Software\Citation\API");
            }
            PostUninstallJobs();
        }

        public static void PostUninstallJobs()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            string content = Resources.postuninstall;
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
                }
            }
        }

        public static void KillServerProcess()
        {
            // check for citationServer.exe if running 
            Process[] serverInstances = Process.GetProcessesByName("citationServer");
            foreach (Process serverInstance in serverInstances)
            {
                serverInstance.Kill();
            }
            // *****
        }

        public static bool InstallFireFox()
        {
            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            Process[] serverInstances = Process.GetProcessesByName("firefox");
            foreach (Process serverInstance in serverInstances)
            {
                serverInstance.Kill();
            }

            var process = new Process();
            if (Environment.OSVersion.Version.Major >= 6)
                process.StartInfo.Verb = "runas"; // This through exception on XP so we check the OS
            process.StartInfo.FileName = path + "\\files\\firefox.exe";
            process.StartInfo.Arguments = "-ms";
            process.StartInfo.WorkingDirectory = path;
            process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

            try
            {
                process.Start();
                process.WaitForExit();
            }
            catch (Exception e) // usually will trigger the catch if the user response with NO in the UAC message
            {
                if (MessageBox.Show("You should press Yes to proceed with this installation, try again?", "Attention",
                                    MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.Yes)
                {
                    return InstallFireFox();
                }
                else
                {
                    return false;
                }
            }

            return true;
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