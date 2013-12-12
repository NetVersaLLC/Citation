using System;
using System.Windows.Forms;

namespace CitationInstaller
{
    public interface ISetupPage
    {
        event EventHandler MoveToNextPage;
        void Initialize(Button cancelButton, Button nextButton, Button backButton);
        void DoAction();
    }
}