namespace CitationInstaller.SetupPages.Dialogs
{
    partial class FrmFireFoxInstances
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.lstInstances = new System.Windows.Forms.ListBox();
            this.label1 = new System.Windows.Forms.Label();
            this.btnCancel = new System.Windows.Forms.Button();
            this.btnRetry = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lstInstances
            // 
            this.lstInstances.FormattingEnabled = true;
            this.lstInstances.HorizontalScrollbar = true;
            this.lstInstances.Location = new System.Drawing.Point(4, 85);
            this.lstInstances.Name = "lstInstances";
            this.lstInstances.Size = new System.Drawing.Size(303, 147);
            this.lstInstances.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 9F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(12, 7);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(286, 68);
            this.label1.TabIndex = 1;
            this.label1.Text = "There is a running instance(s) of FireFox, please make sure to close them all to " +
                "proceed with this installation.";
            this.label1.TextAlign = System.Drawing.ContentAlignment.BottomLeft;
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(212, 243);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(86, 26);
            this.btnCancel.TabIndex = 2;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // btnRetry
            // 
            this.btnRetry.Location = new System.Drawing.Point(107, 243);
            this.btnRetry.Name = "btnRetry";
            this.btnRetry.Size = new System.Drawing.Size(86, 26);
            this.btnRetry.TabIndex = 3;
            this.btnRetry.Text = "Retry";
            this.btnRetry.UseVisualStyleBackColor = true;
            this.btnRetry.Click += new System.EventHandler(this.btnRetry_Click);
            // 
            // FrmFireFoxInstances
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(310, 279);
            this.ControlBox = false;
            this.Controls.Add(this.btnRetry);
            this.Controls.Add(this.btnCancel);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.lstInstances);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "FrmFireFoxInstances";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterParent;
            this.Text = "Running FireFox Instances";
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.ListBox lstInstances;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Button btnRetry;
    }
}