using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
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
        public static string KeyName;

        public static bool IsFirstRun()
        {
            var appKey = Registry.CurrentUser.OpenSubKey(KeyName) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);

            var val = appKey.GetValue("FirstRun");
            appKey.Close();
            if (val != null && val.ToString() == "0")
                return false;

            return true;
        }

        public static void SetFirstRun(bool firstRun)
        {
            var appKey = Registry.CurrentUser.OpenSubKey(KeyName,true) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            appKey.SetValue("FirstRun", firstRun ? 1 : 0, RegistryValueKind.DWord);
            appKey.Close();
        }

        public static void SaveStringSetting(string keyName, string value)
        {
            var appKey = Registry.CurrentUser.OpenSubKey(KeyName, true) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            appKey.SetValue(keyName, value);
            appKey.Close();
        }

        public static string GetStringSetting(string keyName)
        {
            var appKey = Registry.CurrentUser.OpenSubKey(KeyName) ??
                                 Registry.CurrentUser.CreateSubKey(KeyName);
            var val = appKey.GetValue(keyName);
            appKey.Close();
            return val != null ? val.ToString() : "";
        }

        public static void CreateShortcuts()
        {
            var path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            CreateShortcut(Application.ProductName, Assembly.GetExecutingAssembly().Location,
               Application.ProductName + " Start Link",
               "/update", Environment.GetFolderPath(Environment.SpecialFolder.Startup));

            var programFolder = Environment.GetFolderPath(Environment.SpecialFolder.Programs) + "\\" +
                                GetPublisher();

            CreateShortcut("Login", path + "\\files\\login.exe",
                           Application.ProductName + " Login Start Link", "", programFolder);

            CreateShortcut("Restart Citation Server", path + "\\files\\restart.exe",
                           "Restart Citation Server", "", programFolder);
        }

        public static string GetPublisher()
        {
            XDocument xDocument;
            using (var memoryStream = new MemoryStream(AppDomain.CurrentDomain.ActivationContext.DeploymentManifestBytes))
            using (var xmlTextReader = new XmlTextReader(memoryStream))
            {
                xDocument = XDocument.Load(xmlTextReader);
            }
            var description = xDocument.Root.Elements().First(e => e.Name.LocalName == "description");
            var publisher = description.Attributes().First(a => a.Name.LocalName == "publisher");
            return publisher.Value;
        }

        public static bool PostSetupJobs()
        {
            var path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            var content = Resources.postinstall;
            content = content.Replace("%~1", path);
            var tempFile = Path.GetTempFileName() + ".bat";
            File.WriteAllText(tempFile, content);
            if (File.Exists(tempFile))
            {
                var process = new Process();
                if (Environment.OSVersion.Version.Minor >= 6) 
                    process.StartInfo.Verb = "runas"; // This through exception on XP so we check the OS
                process.StartInfo.FileName = tempFile;
                process.StartInfo.WorkingDirectory = path;
                process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;

                process.Start();

                process.WaitForExit();

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
            var assembly = Assembly.GetExecutingAssembly();
            var attribs = assembly.GetCustomAttributes(false);
            var attrib = attribs.FirstOrDefault(a => a.ToString() == "CitationClient.AssemblyPublishUrlAttribute");
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
            var path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            var token = CustomUninstaller.GetPublicKeyToken();
            var keyPath = "";
            var uninstallString = CustomUninstaller.GetUninstallString(token, out keyPath);
            SaveStringSetting("PublicKeyToken", token);
            SaveStringSetting("UninstallString", uninstallString);
            SaveStringSetting("KeyPath", keyPath);
            SaveStringSetting("Publisher", GetPublisher());
            SaveStringSetting("Path", path); // Save the program path in the registry
            ChangeUninstallKey(keyPath, Assembly.GetExecutingAssembly().Location + " /uninstall");
        }

        public static void ChangeUninstallKey(string keyPath, string path)
        {
            var uninstallKey =
                Registry.CurrentUser.OpenSubKey(keyPath, true);

            if (uninstallKey != null)
            {
                uninstallKey.SetValue("UninstallString", path);
                uninstallKey.Close();
            }
        }

        public static void Uninstall()
        {
            var uninstallString = GetStringSetting("UninstallString");

            KillServerProcess();
            CustomUninstaller.Uninstall(uninstallString);

            var link = Environment.GetFolderPath(Environment.SpecialFolder.Startup) + "\\" +
                Application.ProductName + ".lnk";

            if (File.Exists(link))
                File.Delete(link);


            var programFolder = Environment.GetFolderPath(Environment.SpecialFolder.Programs) + "\\" +
                                GetStringSetting("Publisher");

            if (Directory.Exists(programFolder))
                Directory.Delete(programFolder, true);
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

        public static void CopyOldFiles(string newprogramLocation)
        {
            var path = GetStringSetting("Path");
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
            var link = (IShellLink)new ShellLink();

            // setup shortcut information
            link.SetDescription(linkDescription);
            link.SetPath(linkPath);
            link.SetArguments(linkArguments);

            // save it
            var file = (IPersistFile)link;
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
    }
}
