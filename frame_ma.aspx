<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="frame_ma.aspx.cs" Inherits="profiler.frame_ma" %>

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
            var regionID = '<%=regionID%>';
            var url = 'sa_list.aspx?mode=list&source=' + escape($('#selsource').val()) + '&text=' + escape($('#ftext').val());


        });

    </script>

</head>
<body>
    <form id="form1" runat="server">
    <div id="div_res">

        <%
            foreach (dynamic record in records) { %>

        <div class="card">
            <div class="card-body">
                <h4 class="card-title" data-bind="text: ProjectTitle"><%=record["ProjectTitle"]%></h4>
                <p class="card-text" data-bind="text: ProjectDescription"><%=record["ProjectDescription"]%></p>
                <button data-bind="attr: { id: ProjectId }" class="btn btn-primary" data-toggle="modal" data-target="#projectDetailsModal" onclick="load_details(this.id)" id="<%=record["ProjectId"]%>">View</button>
            </div>
        </div>
        <br />
        <% } %>
    </div>
    </form>
</body>
</html>
