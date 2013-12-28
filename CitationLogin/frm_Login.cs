using System;
using System.Windows.Forms;
using System.Net;
using Newtonsoft.Json;
using Microsoft.Win32;

namespace CitationLogin
{
    public partial class frm_Login : Form
    {
        public frm_Login()
        {
            InitializeComponent();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            btnLogin.Enabled = false;
            btnExit.Enabled = false;
            lblstatus.Text = "Status: Logging In.";
            lblstatus.Refresh();

            // Call the json service with the username and password
            // sales@thebathroomsupply.com/crowdGr1p

            try
            {
                //
                string baseURL = Environment.GetEnvironmentVariable("CITATION_HOST", EnvironmentVariableTarget.Machine);

                if (baseURL == null) { baseURL = "https://citation.netversa.com"; }
                
                var json = new WebClient().DownloadString(baseURL + "/users/token.json?email=" + txtLogin.Text.ToString() + "&password=" + txtPassword.Text.ToString());
                apiResponse loginResponse = JsonConvert.DeserializeObject<apiResponse>(json);

                // if the api responds successfully.
                if (loginResponse.success == true)
                {
                    // write the information to the registry
                    RegistryKey key = Registry.CurrentUser.OpenSubKey("Software", true);

                    key.CreateSubKey("Citation");
                    key = key.OpenSubKey("Citation", true);

                    key.CreateSubKey("API");
                    key = key.OpenSubKey("API", true);

                    key.SetValue("auth_token", loginResponse.auth_token.ToString());
                    key.SetValue("business_id", loginResponse.business_id.ToString());

                    // it all worked correctly
                    //lblstatus.Text = "Status: Successful Login. You may now exit the software.";
                    this.Hide();
                    frm_Success frmSuccess = new frm_Success();
                    frmSuccess.ShowDialog();
                }
                else
                {
                    // the api responded but the success flag was false
                    lblstatus.Text = "Status: There was a problem logging in.";
                }

            }
            catch
            {
                // there was a problem talking to the api
                lblstatus.Text = "Status: There was a problem logging in.";
            }

            btnLogin.Enabled = true;
            btnExit.Enabled = true;
        }

        private void btnExit_Click(object sender, EventArgs e)
        {
            Application.Exit(); // everything worked - close the application
        }

        class apiResponse
        {
            public bool success { get; set; }
            public string auth_token { get; set; }
            public int business_id { get; set; }
        }

    }
}
