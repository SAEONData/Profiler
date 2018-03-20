<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="indicator.aspx.cs" Inherits="profiler.indicator" %>

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

</head>
<body>
    <script type="text/javascript">
        function execute() {
            parent.startLoadingBox();
            var url = 'ajax.aspx?mode=tabulate';
            url += '&src=' + escape($('#src').val());
            url += '&cov=' + escape($('#cov').val());
            url += '&fmt=' + escape($('#fmt').val());
            url += '&classMode=' + escape($('#classMode').val());
            url += '&clCont=' + escape($('#clCont').val());
            url += '&scale=' + escape($('#scale').val());
            url += '&offset=' + escape($('#offset').val());
            url += '&disc=' + escape($('#disc').val());
            url += '&date=' + escape($('#date').val());
            url += '&layer=' + escape($('#layer').val());
            url += '&field=' + escape($('#field').val());
            $.ajax(url)
            .done(function (data) {
                parent.endLoadingBox();
                var json = JSON.parse(data);
                if (json.success == true) {
                    debugger;
                }
                else {
                    parent.error(json.message);
                }

            })
            .fail(function () {
                parent.endLoadingBox();
                parent.error("Failed to load gml");
                return;
            })

        }

        function selClassMode() {
            var sm = parseInt($('#classMode').val());
            if (sm == 1) {
                $('#clCont').show();
                $('#clDisc').hide();
            }
            else {
                $('#clDisc').show();
                $('#clCont').hide();
            }
        }

        $(document).ready(function () {
            selClassMode();
        });


    </script>
    <form id="form1" runat="server">
    <div>
        <table>
            <tr>
                <td style="width: 120px">
                    Server:
                </td>
                <td style="width: 400px">
                    <input id="src" class="form-control" type="text" value="<%=Request["src"] %>" />
                </td>
            </tr>
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Coverage:
                </td>
                <td>
                    <input id="cov" class="form-control" type="text" value="<%=Request["cov"] %>" />
                    
                </td>
            </tr>
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Output Format:
                </td>
                <td>
                    <select id="fmt" class="form-control">
                        <option>png</option>
                        <option>tif</option>
                    </select>
                </td>
            </tr>

            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Classification:
                </td>
                <td>
                    <select id="classMode" class="form-control" onchange="selClassMode();">
                        <option value="1">Continuous</option>
                        <option value="2">Discrete</option>
                    </select>
                </td>
            </tr>

            <tbody id="clCont">
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Scale:
                </td>
                <td>
                    <input id="scale" class="form-control" type="text" value="1" />
                    
                </td>
            </tr>
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Offset:
                </td>
                <td>
                    <input id="offset" class="form-control" type="text" value="0" />
                    
                </td>
            </tr>
            </tbody>

            <tbody id="clDisc">
            <tr style="height: 8px"></tr>
            <tr>
                <td style="vertical-align: top">
                    Lookup:
                </td>
                <td>
                    <textarea id="disc" style="height: 96px" class="form-control">0 - NA
1 - Rarely
2 - Often
3 - Always</textarea>
                </td>
            </tr>
            </tbody>


            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Date:
                </td>
                <td>
                    <select id="date" class="form-control">
                        <% 
                            foreach (String date in covdates)
                            {
                                Response.Write("<option>" + date + "</option>");
                            }
                        %>
                    </select>
                </td>
            </tr>
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Destination Layer:
                </td>
                <td>
                    <select id="layer" class="form-control">
                        <option>meso_base_LL</option>
                    </select>
                </td>
            </tr>
            <tr style="height: 8px"></tr>
            <tr>
                <td>
                    Destination Field:
                </td>
                <td>
                    <input id="field" class="form-control" type="text" value="<%=Request["cov"] %>" />
                </td>
            </tr>

        </table>
        <br />
        <input type="button" class="btn btn-default" value="Apply" style="width: 100px"  onclick="execute();" />
    
    </div>
    </form>
</body>
</html>
