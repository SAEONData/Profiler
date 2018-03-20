<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chartbuttons.aspx.cs" Inherits="profiler.chartbuttons" %>

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
    <script type="text/javascript" src="Scripts/busyindicator.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#btnMA').click(function () {
                parent.parent.showMAFrame('');
            });

            $('#btnEvents').click(function () {
                parent.parent.showEventFrame('');
            });


        });
        
    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div>
        <div class="btn-group"> 
            <button id="btnSave" type="button" class="btn btn-default" title="Save Impact Assessment" aria-label="Left Align"><span class="glyphicon glyphicon-floppy-save" aria-hidden="true"></span></button> 
            <button id="btnMA" type="button" class="btn btn-default" title="Mitigation and Adaptation" aria-label="Center Align"><span class="glyphicon glyphicon-screenshot" aria-hidden="true"></span></button> 
            <button id="btnEvents" type="button" class="btn btn-default" title="Events and Declared Disasters" aria-label="Right Align"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span></button> 

        </div>
    </div>
    </form>
</body>
</html>
