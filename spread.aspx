<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="spread.aspx.cs" Inherits="profiler.spread" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        table {
            padding: 0px 0px 0px 0px;
            border-spacing: 0px;
        }

        td {
            width: 100px !important; 
        }

        .lt {
            border-left: 1px solid #e0e0e0;
            border-top: 1px solid #e0e0e0;
        }

        .ltr {
            border-left: 1px solid #e0e0e0;
            border-top: 1px solid #e0e0e0;
            border-right: 1px solid #e0e0e0;
        }

        .ltb {
            border-left: 1px solid #e0e0e0;
            border-top: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
        }

        .ltbr {
            border-left: 1px solid #e0e0e0;
            border-top: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
            border-right: 1px solid #e0e0e0;
        }


    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    <table style="width: <%=(101 * colMax)%>px;">
        <% WriteGrid(); %>
    </table>
    </div>
    </form>
</body>
</html>
