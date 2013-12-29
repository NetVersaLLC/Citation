using System;
using System.Deployment.Application;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace CitationClient
{
    public class CustomInstaller
    {
        #region Properties

        public InPlaceHostingManager InPlaceHostingManager { get; set; }
        public string ProductName { get; set; }
        public bool NoError { get; set; }
        public bool Working { get; set; }
        public Version Version { get; set; }

        #endregion

        #region Methods

        protected virtual void OnErrorHandled()
        {
            EventHandler handler = ErrorHandled;
            if (handler != null) handler(this, EventArgs.Empty);
        }

        protected virtual void OnDownloadApplicationCompleted(DownloadApplicationCompletedEventArgs e)
        {
            EventHandler<DownloadApplicationCompletedEventArgs> handler = DownloadApplicationCompleted;
            if (handler != null) handler(this, e);
        }

        protected virtual void OnDownloadProgressChanged(DownloadProgressChangedEventArgs e)
        {
            EventHandler<DownloadProgressChangedEventArgs> handler = DownloadProgressChanged;
            if (handler != null) handler(this, e);
        }

        public void CheckForUpdate(string deployManifestUriStr)
        {
            NoError = true;
            Working = true;
            try
            {
                var deploymentUri = new Uri(deployManifestUriStr);
                InPlaceHostingManager = new InPlaceHostingManager(deploymentUri, false);
            }
            catch (UriFormatException uriEx)
            {
                OnErrorHandled();
                //MessageBox.Show("Cannot install the application: " +
                //                "The deployment manifest URL supplied is not a valid URL. " +
                //                "NoError: " + uriEx.Message);
                NoError = false;
                return;
            }
            catch (PlatformNotSupportedException platformEx)
            {
                OnErrorHandled();
                //MessageBox.Show("Cannot install the application: " +
                //                "This program requires Windows XP or higher. " +
                //                "NoError: " + platformEx.Message);
                NoError = false;
                return;
            }
            catch (ArgumentException argumentEx)
            {
                OnErrorHandled();
                //MessageBox.Show("Cannot install the application: " +
                //                "The deployment manifest URL supplied is not a valid URL. " +
                //                "NoError: " + argumentEx.Message);
                NoError = false;
                return;
            }

            InPlaceHostingManager.GetManifestCompleted += iphm_GetManifestCompleted;
            InPlaceHostingManager.GetManifestAsync();
        }

        private void iphm_GetManifestCompleted(object sender, GetManifestCompletedEventArgs e)
        {
            // Check for an error. 
            if (e.Error != null)
            {
                OnErrorHandled();
                // Cancel download and install.
                //MessageBox.Show("Could not download manifest. NoError: " + e.NoError.Message);
                NoError = false;
                return;
            }

            // bool isFullTrust = CheckForFullTrust(e.ApplicationManifest); 

            // Verify this application can be installed. 
            try
            {
                // the true parameter allows InPlaceHostingManager 
                // to grant the permissions requested in the applicaiton manifest.
                InPlaceHostingManager.AssertApplicationRequirements(true);
            }
            catch (Exception ex)
            {
                OnErrorHandled();
                //MessageBox.Show("An error occurred while verifying the application. " +
                //                "NoError: " + ex.Message);
                NoError = false;
                return;
            }
            ProductName = e.ProductName;
            // Use the information from GetManifestCompleted() to confirm  
            // that the user wants to proceed. 
            //string appInfo = "Application Name: " + e.ProductName;
            //appInfo += "\nVersion: " + e.Version;
            //appInfo += "\nSupport/Help Requests: " + (e.SupportUri != null ?
            //    e.SupportUri.ToString() : "N/A");
            //appInfo += "\n\nConfirmed that this application can run with its requested permissions.";
            //// if (isFullTrust) 
            //// appInfo += "\n\nThis application requires full trust in order to run.";
            //appInfo += "\n\nProceed with installation?";

            //DialogResult dr = MessageBox.Show(appInfo, "Confirm Application Install",
            //    MessageBoxButtons.OKCancel, MessageBoxIcon.Question);
            //if (dr != System.Windows.Forms.DialogResult.OK)
            //{
            //    return;
            //}

            // Download the deployment manifest. 
            InPlaceHostingManager.DownloadProgressChanged += iphm_DownloadProgressChanged;
            InPlaceHostingManager.DownloadApplicationCompleted += iphm_DownloadApplicationCompleted;

            try
            {
                // Usually this shouldn't throw an exception unless AssertApplicationRequirements() failed,  
                // or you did not call that method before calling this one.
                Version = e.Version;
                Working = false;
            }
            catch (Exception downloadEx)
            {
                OnErrorHandled();
                //MessageBox.Show("Cannot initiate download of application. NoError: " +
                //                downloadEx.Message);
                NoError = false;
                return;
            }
        }

        public bool Update()
        {
            NoError = true;
            Working = true;
            InPlaceHostingManager.DownloadApplicationAsync();
            return true;
        }

        private void iphm_DownloadApplicationCompleted(object sender, DownloadApplicationCompletedEventArgs e)
        {
            if (e.Error != null)
            {
                // Cancel download and install.
                //MessageBox.Show("Could not download and install application. Error: " + e.Error.Message);
                NoError = false;
                return;
            }
            CreateWindowsStartup(ProductName, e.ShortcutAppId, true, true);
            Working = false;
        }

        private void iphm_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            OnDownloadProgressChanged(e);
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

        #endregion

        public event EventHandler<DownloadProgressChangedEventArgs> DownloadProgressChanged;
        public event EventHandler<DownloadApplicationCompletedEventArgs> DownloadApplicationCompleted;
        public event EventHandler ErrorHandled;
    }

    [AttributeUsage(AttributeTargets.Assembly)]
    public class AssemblyPublishUrlAttribute : Attribute
    {
        #region Constructor/Destructor

        public AssemblyPublishUrlAttribute(string url)
        {
            PublishUrl = url;
        }

        #endregion

        #region Properties

        public string PublishUrl { get; set; }

        #endregion
    }
}