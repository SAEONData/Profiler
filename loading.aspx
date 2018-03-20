<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="loading.aspx.cs" Inherits="profiler.loading" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        body {
            font-family: Arial;
            font-size: 14pt;
            text-align: center;
            margin-top: 20px;
        }
        
    </style>
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            parent.loadRealURL();
        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <img src="images/ajax-loader.gif" alt="Loading..." />
    </div>
    </form>
</body>
</html>
