using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages
{
    public partial class PgInstallProgress : UserControl, ISetupPage
    {
        #region Private Fields

        private Button _backButton;
        private Button _cancelButton;

        private CustomInstaller _installer;
        private Button _nextButton;

        #endregion

        #region Constructor/Destructor

        public PgInstallProgress()
        {
            InitializeComponent();
            UpdateApplicationName();
        }

        #endregion

        #region Methods

        private void _installer_ErrorHandled(object sender, EventArgs e)
        {
            lblProgressText.Text = "Downloading process was canceled";
        }

        private void installer_DownloadApplicationCompleted(object sender, DownloadApplicationCompletedEventArgs e)
        {
            // Check for an error. 
            if (e.Error != null)
            {
                // Cancel download and install.
                lblProgressText.Text = "Downloading process was canceled";
                MessageBox.Show("Could not download and install application. Error: " + e.Error.Message);
                return;
            }
            lblProgressText.Text = "Installing files completed ...";
            Thread.Sleep(500);
            lblProgressText.Text = "Creating shourtcut ...";
            CreateWindowsStartup(_installer.ProductName, e.ShortcutAppId, true, true);
            Thread.Sleep(500);
            lblProgressText.Text = "Installation completed ...";
            Thread.Sleep(1000);
            _nextButton.Enabled = true;
            OnMoveToNextPage();
        }

        private void installer_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            lblProgressText.Text =
                string.Format("Downloading installation files {2}%\nDownloaded {0:0.00}KB of {1:0.00}KB",
                              e.BytesDownloaded/1024.0,
                              e.TotalBytesToDownload/1024.0, e.ProgressPercentage);
            prgInstallProgress.Value = e.ProgressPercentage;
        }

        private void UpdateApplicationName()
        {
            foreach (object ctrl in Controls)
            {
                if (ctrl.GetType() == typeof (Label))
                {
                    var label = ctrl as Label;
                    label.Text = label.Text.Replace("#ApplicationName#", Application.ProductName);
                }
            }
        }

        private void CreateWindowsStartup(string productName, string activationUrl, bool create, bool runit)
        {
            string startupFileName = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData) + "\\" +
                                     productName +
                                     ".appref-ms";
            if (create)
            {
                if (!File.Exists(startupFileName))
                {
                    using (var fs = new FileStream(startupFileName, FileMode.Create))
                    {
                        using (var sw = new StreamWriter(fs, Encoding.Unicode))
                        {
                            sw.WriteLine(activationUrl);
                        }
                    }
                }
                if (runit)
                {
                    var process = new Process();
                    process.StartInfo.FileName = startupFileName;
                    process.Start();

                    while (!process.HasExited)
                    {
                        Application.DoEvents();
                    }
                }
            }
            else
            {
                if (File.Exists(startupFileName))
                {
                    File.Delete(startupFileName);
                }
            }
        }


        protected virtual void OnMoveToNextPage()
        {
            EventHandler handler = MoveToNextPage;
            if (handler != null) handler(this, EventArgs.Empty);
        }

        #endregion

        #region ISetupPage Members

        public event EventHandler ExitSetup;
        public event EventHandler MoveToNextPage;
        public event EventHandler MoveToPreviousPage;

        public void Initialize(Button cancelButton, Button nextButton, Button backButton)
        {
            _cancelButton = cancelButton;
            _nextButton = nextButton;
            _backButton = backButton;
        }


        public void DoAction()
        {
            _nextButton.Enabled = false;
            _backButton.Enabled = false;

            _installer = new CustomInstaller();
            _installer.DownloadProgressChanged += installer_DownloadProgressChanged;
            _installer.DownloadApplicationCompleted += installer_DownloadApplicationCompleted;
            _installer.ErrorHandled += _installer_ErrorHandled;

            if (_installer.CheckOldVersion())
            {
                lblProgressText.Text = "Removing old version ...";
                _installer.UninstallOldVersion();
                lblProgressText.Text = "installing the new version ...";
            }
#if DEBUG
            _installer.InstallApplication("http://sameer-hpc/citation/AllSearch52.application");
#else
            Assembly assembly = Assembly.GetExecutingAssembly();
            object[] attribs = assembly.GetCustomAttributes(false);
            object attrib = attribs.FirstOrDefault(a => a.ToString() == "CitationInstaller.AssemblyPublishUrlAttribute");
            if (attrib != null)
            {
                var att = attrib as AssemblyPublishUrlAttribute;
                _installer.InstallApplication(att.PublishUrl);
            }
#endif
            lblProgressText.Text = "Preparing to download files from the server ...";
        }

        #endregion
    }
}