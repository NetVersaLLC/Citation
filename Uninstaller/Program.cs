using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Windows.Forms;
using Microsoft.Win32;
using Uninstaller.Properties;

namespace Uninstaller
{
    static class Program
    {
        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        [STAThread]
        static void Main(string[] args)
        {

            if(args.Length == 0)
                return;

            string keyName = args[0];

            string uninstallString = GetStringSetting(keyName, "UninstallString");
            string path = GetStringSetting(keyName, "Path");
            string productName = GetStringSetting(keyName, "Product");


            KillRuningProcess("citationServer", path);// check and kill citationServer.exe if running 
            KillRuningProcess("login", path);// check and kill login.exe if running 

            CustomUninstaller.Uninstall(uninstallString);
            var key = Registry.CurrentUser.OpenSubKey(GetStringSetting(keyName, "KeyPath"));
            if (key != null)
            {
                key.Close();
                return;
            }

            string link = Environment.GetFolderPath(Environment.SpecialFolder.Startup) + "\\" +
                          productName + ".lnk";

            if (File.Exists(link))
                File.Delete(link);


            string programFolder = Environment.GetFolderPath(Environment.SpecialFolder.Programs) + "\\" +
                                   GetStringSetting(keyName, "Publisher");

            if (Directory.Exists(programFolder))
                Directory.Delete(programFolder, true);

            DeleteRegistryKey(keyName);
            DeleteRegistryKey(@"Software\Citation\API");

            PostUninstallJobs();

            if (Directory.Exists(path))
                Directory.Delete(path, true);

            MessageBox.Show("Application successfully removed.", productName);
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

        public static string GetStringSetting(string keyName, string valueName)
        {
            RegistryKey appKey = Registry.CurrentUser.OpenSubKey(keyName);
            if (appKey == null)
                return "";

            object val = appKey.GetValue(valueName);
            appKey.Close();
            return val != null ? val.ToString() : "";
        }

        public static void DeleteRegistryKey(string keyName)
        {
            var key = Registry.CurrentUser.OpenSubKey(keyName);
            if (key != null)
            {
                key.Close();
                Registry.CurrentUser.DeleteSubKeyTree(keyName);
            }    
        }

        public static void KillRuningProcess(string processName, string path)
        {
            Process[] serverInstances = Process.GetProcessesByName(processName);
            foreach (Process serverInstance in serverInstances)
            {
                //if (serverInstance.MainModule == null || serverInstance.MainModule.FileName.ToLower().Contains(path.ToLower()))
                    serverInstance.Kill();
            }
            // *****
        }

    }
}
