using System;
using System.Windows.Forms;

namespace CitationInstaller.SetupPages.Dialogs
{
    public partial class FrmFireFoxInstances : Form
    {
        #region Constructor/Destructor

        public FrmFireFoxInstances()
        {
            InitializeComponent();
            FillList();
        }

        #endregion

        #region Methods

        private void btnRetry_Click(object sender, EventArgs e)
        {
            FillList();
            if (lstInstances.Items.Count == 0)
            {
                DialogResult = DialogResult.OK;
                Close();
            }
        }

        private void FillList()
        {
            string[] instances = InstallerJobs.GetFireFoxInstances();
            lstInstances.Items.Clear();
            lstInstances.Items.AddRange(instances);
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("This will end the Setup, are you sure?", "Attention",
                                MessageBoxButtons.YesNo,
                                MessageBoxIcon.Warning) == DialogResult.Yes)
            {
                DialogResult = DialogResult.Cancel;
                Close();
            }
        }

        #endregion
    }
}