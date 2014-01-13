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
                    // Check and extract FireFox portable.
                    if(!File.Exists(path + "\\files\\FirefoxPortable\\App\\Firefox\\firefox.exe"))
                        LauncherJobs.InstallFireFox();
                    // *************

                    if (LauncherJobs.PostSetupJobs())
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
                    if (MessageBox.Show(
                        string.Format("This will remove {0} from your applications, are you sure?",
                                     Application.ProductName),"Warning!",
                                     MessageBoxButtons.YesNo, MessageBoxIcon.Warning) == DialogResult.No)
                        return;
                    LauncherJobs.Uninstall();
                }
                return;
            }

            // double check, to ensure that the runing instance of citationServer is the latest
            LauncherJobs.KillRuningProcess("citationServer");// check and kill citationServer.exe if running 


            // Finaly launch citationServer
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