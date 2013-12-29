using System;
using System.Windows.Forms;

namespace CitationInstaller
{
    internal static class Program
    {
        #region Methods

        /// <summary>
        ///     The main entry point for the application.
        /// </summary>
        [STAThread]
        private static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);

            var frm = new FrmMain();
            frm.Text = Application.ProductName + " Setup";

            Application.Run(frm);
        }

        #endregion
    }
}