using System;
using System.Windows.Forms;

namespace CitationInstaller
{
    public interface ISetupPage
    {
        #region Methods

        void Initialize(Button cancelButton, Button nextButton, Button backButton);
        void DoAction();

        #endregion

        event EventHandler MoveToNextPage;
        event EventHandler MoveToPreviousPage;
        event EventHandler ExitSetup;
    }
}