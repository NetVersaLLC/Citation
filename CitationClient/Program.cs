using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.InteropServices.ComTypes;
using System.Threading;
using System.Windows.Forms;
using CitationClient.Properties;
using System.Linq;

namespace CitationClient
{
    internal static class Program
    {
        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main(string[] args)
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

#if DEBUG
            MessageBox.Show("Version " + Assembly.GetExecutingAssembly().GetName().Version);
#endif

            string path = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location);
            Process process;
            if (ApplicationDeployment.IsNetworkDeployed)
            {
                ApplicationDeployment application =
                    ApplicationDeployment.CurrentDeployment;

                if (application.IsFirstRun)
                {
                    CreateShortcut(Application.ProductName, Assembly.GetExecutingAssembly().Location,
                                   Application.ProductName + " Start Link",
                                   "/update");
                    CreateShortcut(Application.ProductName + " Login", path + "\\files\\login.exe",
                                   Application.ProductName + " Login Start Link", "");
                    Properties.Settings.Default.PublicKeyToken = ClickOnceUninstaller.GetPublicKeyToken();
                    Properties.Settings.Default.Save();
                }

                if (Settings.Default.FirstRun)
                {
                    string content = Resources.postinstall;
                    content = content.Replace("%~1", path);
                    string tempFile = Path.GetTempFileName() + ".bat";
                    File.WriteAllText(tempFile, content);
                    if (File.Exists(tempFile))
                    {
                        process = new Process();
                        if (Environment.OSVersion.Version.Minor >= 6)
                            process.StartInfo.Verb = "runas";
                        process.StartInfo.FileName = tempFile;
                        process.StartInfo.WorkingDirectory = path;
#if !DEBUG
                    process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
#else
                        process.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
#endif
                        process.Start();

                        process.WaitForExit();

                        File.Delete(tempFile);

                        process = new Process();
                        process.StartInfo.FileName = path + "\\files\\login.exe";
                        process.StartInfo.WorkingDirectory = path + "\\files";
                        process.StartInfo.WindowStyle = ProcessWindowStyle.Normal;
                        process.Start();
                        
                        Settings.Default.FirstRun = false;
                        Settings.Default.Save();
                    }
                }
            }

            if (args.Length > 0 && args[0].ToLower() == "/update")
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
                        // check for citationServer.exe if running 
                        Process[] serverInstances = Process.GetProcessesByName("citationServer");
                        foreach (Process serverInstance in serverInstances)
                        {
                            serverInstance.Kill();
                        }
                        // *****
                        bool updated = updater.Update();
                        while (updater.NoError && updater.Working)
                        {
                            Application.DoEvents();
                            Thread.Sleep(100);
                        }
                        // Uninstalling and re-installing the application will request to run the batch file again so I've commented it.
                        //ClickOnceUninstaller.Uninstall(Properties.Settings.Default.PublicKeyToken);
#if DEBUG
                    MessageBox.Show("Updated " + updater.Version.ToString());
#endif
                        return;
                    }
                }
            }

            process = new Process();
            process.StartInfo.FileName = path + "\\files\\citationServer.exe";
            process.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            process.Start();
        }

        private static void CreateShortcut(string linkName, string linkPath, string linkDescription,
                                           string linkArguments)
        {
            var link = (IShellLink) new ShellLink();

            // setup shortcut information
            link.SetDescription(linkDescription);
            link.SetPath(linkPath);
            link.SetArguments(linkArguments);

            // save it
            var file = (IPersistFile) link;
            string startupPath = Environment.GetFolderPath(Environment.SpecialFolder.Startup);
            string shortcut = Path.Combine(startupPath, linkName + ".lnk");
            if (File.Exists(shortcut))
                File.Delete(shortcut);
            file.Save(shortcut, false);
        }
    }
}
