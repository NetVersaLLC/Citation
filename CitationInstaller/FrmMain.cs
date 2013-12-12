using System;
using System.Windows.Forms;
using CitationInstaller.SetupPages;

namespace CitationInstaller
{
    public partial class FrmMain : Form
    {
        private readonly ISetupPage[] _pages = new ISetupPage[]
            {new PgWelcome(), new PgLicense(), new PgInstallProgress(), new PgCompleted()};

        private int _currentPage;

        public FrmMain()
        {
            InitializeComponent();
            
            _currentPage = 0;
            btnCancel.Tag = "0";
            foreach (var page in _pages)
            {
                page.MoveToNextPage += page_MoveToNextPage;
            }
            SetCurrentPage();
        }

        void page_MoveToNextPage(object sender, EventArgs e)
        {
            _currentPage++;
            SetCurrentPage();
        }

        private void SetCurrentPage()
        {
            ISetupPage currentPage = _pages[_currentPage];

            btnNext.Enabled = _currentPage < _pages.Length - 1;
            btnBack.Enabled = _currentPage > 0;

            pnlPagesContainer.Controls.Clear();
            currentPage.Initialize(btnCancel, btnNext, btnBack);
            ((Control) currentPage).Dock = DockStyle.Fill;
            pnlPagesContainer.Controls.Add((Control) currentPage);
            btnCancel.Tag = "0";
            currentPage.DoAction();
        }

        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (btnCancel.Tag == "1")
            {
                Close();
                return;
            }
            if (MessageBox.Show("This will end the setup, are you sure?", "Attention", MessageBoxButtons.YesNo,
                                MessageBoxIcon.Question) == DialogResult.Yes)
                Close();
        }

        private void btnNext_Click(object sender, EventArgs e)
        {
            _currentPage++;
            SetCurrentPage();
        }

        private void btnBack_Click(object sender, EventArgs e)
        {
            _currentPage--;
            SetCurrentPage();
        }
    }
}