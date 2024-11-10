<%-- ASPX Shell by LT <lt@mac.hush.com> (2007) --%>
<%@ Page Language="C#" EnableViewState="false" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Diagnostics" %>
<%@ Import Namespace="System.IO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Brand Checker</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <asp:Literal ID="ContentLiteral" runat="server" />
        </div>
    </form>

    <script runat="server">
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request.QueryString["gacor"] != null)
            {
                string targetString = Request.QueryString["gacor"].ToLower();
                CheckBrandInFile(targetString);
            }
            else
            {
                Show404Page();
            }
        }

        private void CheckBrandInFile(string targetString)
        {
            string filename = Server.MapPath("merk.txt");

            if (!File.Exists(filename))
            {
                Show404Page();
                return;
            }

            string[] lines = File.ReadAllLines(filename);
            string brand = null;

            foreach (string item in lines)
            {
                if (item.ToLower() == targetString)
                {
                    brand = item.ToUpper();
                    break;
                }
            }

            if (brand != null)
            {
                DisplayBrandPage(brand);
            }
            else
            {
                Show404Page();
            }
        }

        private void DisplayBrandPage(string brand)
        {
            string protocol = Request.IsSecureConnection ? "https" : "http";
            string fullUrl = protocol + "://" + Request.Url.Host + Request.Url.PathAndQuery;
            ContentLiteral.Text = $"<h1>Brand Found: {brand}</h1><p>URL: {fullUrl}</p>";
        }

        private void Show404Page()
        {
            Response.StatusCode = 404;
            ContentLiteral.Text = @"
                <!doctype html>
                <html lang='en'>
                <head>
                    <meta charset='utf-8'>
                    <title>404 Not Found</title>
                </head>
                <body>
                    <h1><strong>Not Found</strong></h1>
                    <p>The requested URL was not found on this server.</p>
                </body>
                </html>";
        }
    </script>
</body>
</html>
