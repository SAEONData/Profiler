<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="grab.aspx.cs" Inherits="profiler.grab" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/bootstrap-responsive.css" rel="stylesheet" />
    <link href="Content/bootstrap-theme.css" rel="stylesheet" />
    <link href="Content/bootstrap-slider.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap.min.js"></script>
    <script type='text/javascript' src="Scripts/bootstrap-slider.js"></script>
    <script type="text/javascript" src="Scripts/busyindicator.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap-modal.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap-modalmanager.js"></script>

    <script type="text/javascript">

        function grab() {
            var url = $('#url').val();
            var url = 'ajax.aspx?mode=grab&url=' + escape(url);
            ajaxindicatorstart('Loading...');
            $.ajax(url, { timeout: 3000 })
            .done(function (data) {
                ajaxindicatorstop();
                $('#res').html(data);
            })
            .fail(function (e) {
                ajaxindicatorstop();
                debugger;
                $('#res').html(e.responseText);
            })
        }

   </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        Enter URL:
        <br />
        <input type="text" class="form-control" style="width: 50%" id="url" />
        <br />
        <input type="button" value="Submit" class="btn btn-default" onclick="grab();" />
        <br />
        <br />
        <div class="form-control" style="width: 50%; height: 400px" id="res" />


    
    </div>
    </form>
</body>
</html>
