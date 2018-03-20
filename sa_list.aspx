<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="sa_list.aspx.cs" Inherits="profiler.sa_list" %>

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
    
    <style type="text/css">
        body {
            padding: 7px;
        }
    </style>

    <script type="text/javascript">


        function resizeGraphBox() {

            var offset = -80;
            var cy = $(window).height();
            var cx = $(window).width();
            $('#resbox').height(cy - (197 - offset));
        }

        function doSearch(key) {
            if (key == null)
                parent.parent.ajaxindicatorstart('Loading..');
            var url = 'sa_list.aspx?mode=list&source=' + escape($('#selsource').val()) + '&text=' + escape($('#ftext').val());
            $('#resbox').html('Loading...');
            $('#resbox').load(url, function () {
                if (key == null)
                    parent.parent.ajaxindicatorstop();
                $('.gslink').click(function (evt) {
                    evt.preventDefault();
                    var id = $(this).attr('href').substr(1);
                    var url = 'sa_list.aspx?mode=getfeature&source=' + escape($('#selsource').val()) + '&id=' + escape(id);
                    parent.parent.ajaxindicatorstart('Loading..');
                    $.ajax(url).complete(function (f) {
                        var args = f.responseText.split('|');
                        var id = args[0];
                        var name = args[1];
                        parent.parent.ajaxindicatorstop();
                        parent.parent.addPage(name, 'grid.aspx?id=' + escape(id), 'glyphicon-th');
                    });
                });
            });
        }



        $(document).ready(function () {
            $(window).on('resize', resizeGraphBox);
            resizeGraphBox();


            $('#selFeature').change(function () {
                var fid = $('#selFeature').val();
                var url = 'sa_list.aspx?mode=getSources&fid=' + escape(fid);
                $.ajax(url).complete(function (a, b, c) {
                    $('#selsource').html(a.responseText);
                    $('#selsource').trigger('change');
                })
            });


            $('#selsource').change(function () {
                $('#ftext').val('');
                doSearch();
            });

            $('#selFeature').trigger('change');



        });

        /*

<wfs:GetFeature xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://www.opengis.net/wfs http://giswebservices.massgis.state.ma.us/geoserver/schemas/wfs/1.0.0/WFS-basic.xsd"
    xmlns:gml="http://www.opengis.net/gml"
    xmlns:wfs="http://www.opengis.net/wfs"
    xmlns:ogc="http://www.opengis.net/ogc"
    service="WFS"
    version="1.0.0">
    <wfs:Query typeName="massgis:GISDATA.TOWNS_POLY" xmlns:massgis="http://massgis.state.ma.us/featuretype">
        <ogc:Filter>
            <ogc:PropertyIsEqualTo>
                <ogc:PropertyName>TOWN</ogc:PropertyName>
                <ogc:Literal>HANCOCK</ogc:Literal>
            </ogc:PropertyIsEqualTo>
        </ogc:Filter>
    </wfs:Query>
</wfs:GetFeature>


        */

    </script>

</head>
<body>
    <form id="form1" runat="server" onsubmit="doSearch(); return false;">
    <div>
        Area Type:
        <select class="form-control" id="selFeature">
            <% for (int i = 0; i < gstool.groups.Count; i++)
               { %>
            <option><%=gstool.groups[i].name%></option>
            <% } %>
        </select>
        <br />
        Sub Type:
        <select class="form-control" id="selsource">
        </select>
        <br />
        Find:
        <div class="input-group">
            <input type="text" class="form-control" placeholder="Search" id="ftext" name="textFilter" value="" onkeyup="doSearch(1);" />
            <div class="input-group-btn textFilter">
                <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search" onclick="doExtentFilter();"></i></button>
            </div>
        </div>

        <br />
        List:
        <div class="form-control" style="height: 200px; overflow-y: auto" id="resbox" >
        </div>

    </div>
    </form>
</body>
</html>
