using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

namespace CitationClient
{
    internal static class Program
    {
        #region Methods

        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            LauncherJobs.KeyName = "Software\\" + Application.ProductName;

            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            if (ApplicationDeployment.IsNetworkDeployed)
            {
                // This will run first time the application started even after update.
                if (ApplicationDeployment.CurrentDeployment.IsFirstRun)
                {
                    LauncherJobs.CreateShortcuts(); // Create shortcuts
                    LauncherJobs.CopyOldFiles(path); // Copy old files after update.
                    // Save the Public Ket Token of the program, Uninstall string - this will be used in the Uninstaller process
                    LauncherJobs.SaveInformation();
                }
                // *********************************

                // This will run early first time the application started after the installation.
                if (LauncherJobs.IsFirstRun())
                {
                    if (LauncherJobs.InstallFireFox() && LauncherJobs.PostSetupJobs())

                    // here i need to test the operating system and only run when it is windows 8

                    //Version win8version = new Version(6, 2, 9200, 0);

                    //if (OSVersion.Platform == PlatformID.Win32NT &&
                    //    Environment.OSVersion.Version >= win8version)
                    //{
                    //    // its win8 or higher.
                    //}

                    

                    string content = Resources.postinstall;
                    content = content.Replace("%~1", path);
                    string tempFile = Path.GetTempFileName() + ".bat";
                    File.WriteAllText(tempFile, content);
                    if (File.Exists(tempFile))
                    {
                        LauncherJobs.SetFirstRun(false);
                    }
                    else
                    {
                        // Not respond to UAC with Yes so Rollback the installation
                        LauncherJobs.Uninstall();
                    }
                    // ********************************
                }
            }

            if (args.Length > 0)
            {
                if (args[0].ToLower() == "/update")
                {
                    LauncherJobs.Update(); // Run update process
                }
                else if (args[0].ToLower() == "/uninstall")
                {
                    LauncherJobs.Uninstall();
                }
                return;
            }


            // Finaly launch citationServer
            LauncherJobs.KillServerProcess();
            var process = new Process
                {
                    StartInfo =
                        {
                            FileName = path + "\\files\\citationServer.exe",
                            WindowStyle = ProcessWindowStyle.Hidden
                        }
                };
            process.Start();
            // ************************

        }

        #endregion
    }
}
