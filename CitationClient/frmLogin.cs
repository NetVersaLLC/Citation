using Microsoft.Win32;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Text;
using System.Windows.Forms;

namespace CitationClient
{
    public partial class frmLogin : Form
    {
        public frmLogin()
        {
            InitializeComponent();
        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            // Call the json service with the username and password
            // sales@thebathroomsupply.com/crowdGr1p

            try
            {
                var json = new WebClient().DownloadString("https://citation.netversa.com/users/token.json?email=" + txtLogin.Text.ToString() + "&password=" + txtPassword.Text.ToString());
                apiResponse loginResponse = JsonConvert.DeserializeObject<apiResponse>(json);

                // if the api responds successfully.
                if (loginResponse.success == true)
                {
                    // write the information to the registry

                    // First of all if you want to edit key under LocalMachine you must run your application under admin rights

                    RegistryKey key = Registry.LocalMachine.OpenSubKey("Software", true);

                    key.CreateSubKey("Citation");
                    key = key.OpenSubKey("Citation", true);

                    key.CreateSubKey("API");
                    key = key.OpenSubKey("API", true);

                    //key.SetValue("trevis", "cool");
                    key.SetValue("auth_token", loginResponse.auth_token.ToString());
                    key.SetValue("business_id", loginResponse.business_id.ToString());
                }
                else
                {
                    // the api responded but the success flag was false
                }

                int i;
            }
            catch
            {
                // there was a problem talking to the api
            }




            string trev;
        }

        class apiResponse
        {
            public bool success { get; set; }
            public string auth_token { get; set; }
            public int business_id { get; set; }
        }
    }
}
