<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="prof.aspx.cs" Inherits="profiler.prof" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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


    <style type="text/css">
        .vertical-text {
            transform: rotate(270deg);
            transform-origin: left top 0;
        }

        #chartbox {
            border: 1px solid #e0e0e0;
            width: 100%;
        }

        .whiteHat {
            border: none;
            position: absolute;
        }

        .pageFrame {
            border-top: 0px;
            border-left: 1px solid #e0e0e0;
            border-right: 1px solid #e0e0e0;
            border-bottom: 1px solid #e0e0e0;
            padding: 10px;
            width: 100%;
        }


        body {
            padding-right: 10px;
        }

    </style>

    <script type="text/javascript">

        var global = {};
        global.relframe = '<%=Request["relframe"]%>';
        global.cellid = '<%=Request["cellid"]%>';




        function resizeGraphBox() {

            var offset = 0;

            var cy = $(window).height();
            var cx = $(window).width();
            $('.pageFrame').height(cy - (90 - offset));
        }



        $(document).ready(function () {
            $(window).on('resize', resizeGraphBox);
            $('.pageFrame').hide();
            resizeGraphBox();

            var v1 = '<%=v1%>';
            var v2 = '<%=v2%>';
            if (v2 != '') {
                // $('#btn_chartFrame').hide();
            }

            $('.pageButton').click(function () {
                $('.pageButton').removeClass('active');
                $('#' + this.id).addClass('active');

                $('.pageFrame').hide();
                $('#' + this.id.substr(4)).show();
            })

            $('#btn_mapFrame').trigger('click');

            /*
            $('#btn_MaFrame').hide();
            $('#btn_EventFrame').hide();
            */

        });

        function startLoadingBox(cap) {
            ajaxindicatorstart(cap ? cap : 'Loading...');
        }

        function endLoadingBox() {
            ajaxindicatorstop();
        }

        function error(msg, retfunc) {
            $('#error-msg').html(msg);
            $('#dlgError').modal();
        }


        function addDataSource(srv) {
            global.addsrv = srv;
            startLoadingBox();
            var url = 'ajax.aspx?mode=parseGetCapabilities&url=' + escape(srv);
            $.ajax(url)
            .done(function (data) {
                endLoadingBox();
                var json = JSON.parse(data);
                if (json.success == true) {
                    $('#selCovBox').empty();
                    for (var c in json.coverages) {
                        var coverage = json.coverages[c];
                        $('#selCovBox').append('<option>' + coverage + '</option>');
                    }
                    $('#selCovBoxBtn').trigger('click');
                }
                else {
                    error(json.message);
                }

            })
            .fail(function () {
                endLoadingBox();
                error("Failed to load gml");
                return;
            })
        }

        function selCoverage() {
            var cov = $('#selCovBox').val();
            if (cov == null) {
                error('Please select a coverage');
                return;
            }
            $('#selCovBoxBtn').trigger('click');
            global.addcov = cov;

            var url = 'ajax.aspx?mode=parseDescribeCoverage&url=' + escape(global.addsrv) + '&cov=' + escape(cov);
            $.ajax(url)
            .done(function (data) {
                endLoadingBox();
                var json = JSON.parse(data);
                if (json.success == true) {
                    $('.pageFrame').hide();
                    $('#indicatorFrame').attr('src', 'indicator.aspx?cov=' + escape(cov) + '&src=' + escape(global.addsrv));
                    $('#indicatorFrame').show();
                }
                else {
                    error(json.message);
                }
            })
            .fail(function () {
                endLoadingBox();
                error("Failed to load gml");
                return;
            })

        }

        function showChartFrame(url) {
            global.url = url;
            $('#chartFrame').attr('src', 'loading.aspx');
            $('#btn_chartFrame').show();
            $('#btn_chartFrame').trigger('click');
            setTimeout(function () {
                $('#chartFrame').attr('src', global.url);
            }, 500);
        }

        function loadRealURL() {
            $('#chartFrame').attr('src', global.url);

        }

        function getChartURL() {
            var v2 = '<%=v2%>';
            if (v2 == '')
                return;

            
            var url = 'chartinfo.aspx';
            try {
                url = window.frames["gridFrame"].getChartURL();
            }
            catch (e) {
                $('#chartFrame').attr('src', global.url);
            }

            if (url == 'chartinfo.aspx') {
                $('#chartFrame').attr('src', url);
            }
            else {
                global.url = url;
                $('#chartFrame').attr('src', 'loading.aspx');
            }
            $('#btn_chartFrame').show();
            
        }

        function showMAFrame(url) {
            $('#btn_MaFrame').show();
            $('#btn_MaFrame').trigger('click');
        }

        function showEventFrame() {
            $('#btn_EventFrame').show();
            $('#btn_EventFrame').trigger('click');
        }


    </script>
</head>
<body style="padding-left: 10px; overflow-x: hidden; overflow-y: hidden">
    <form id="form1" runat="server">

        <ul class="nav nav-tabs">
          <li id="btn_mapFrame" role="presentation" class="pageButton active"><a href="#"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span>&nbsp;Map</a></li>
          <% if (v2 != "" && v2 != null)
             { %>
          <li id="btn_gridFrame" role="presentation" class="pageButton"><a href="#"><span class="glyphicon glyphicon-align-justify" aria-hidden="true"></span>&nbsp;Grid</a></li>
          <% } %>
          <li id="btn_chartFrame" role="presentation" class="pageButton" onclick="getChartURL();"><a href="#"><span class="glyphicon glyphicon-signal" aria-hidden="true"></span>&nbsp;Chart</a></li>
          <% if (v2 != "" && v2 != null) { %>
          <li id="btn_MaFrame" role="presentation" class="pageButton"><a href="#"><span class="glyphicon glyphicon-screenshot" aria-hidden="true"></span>&nbsp;Mitigation and Adaptation</a></li>
          <li id="btn_EventFrame" role="presentation" class="pageButton"><a href="#"><span class="glyphicon glyphicon-calendar" aria-hidden="true"></span>&nbsp;Events</a></li>
          <% } %>
        </ul>
        <!-- Main component for a primary marketing message or call to action -->
        <iframe class="pageFrame" id="mapFrame" name="mapFrame" src="map.aspx?id=<%=Request["id"]%>&v1=<%=v1%>&v2=<%=v2%>" ></iframe>
        <iframe class="pageFrame" id="chartFrame" name="chartFrame" src="<%=chartFrameSrc%>"></iframe>
        <iframe class="pageFrame" id="gridFrame" name="gridFrame" src="chart.aspx?id=<%=Request["id"]%>&v1=<%=v1%>&v2=<%=v2%>"></iframe>

        <iframe class="pageFrame" id="MaFrame" name="gridFrame" src="http://app01.saeon.ac.za/nccrdjdt/projects.html?regionId=<%=regionID%>"></iframe>
        <iframe class="pageFrame" id="EventFrame" name="gridFrame" src="frame_events.aspx?id=<%=Request["id"]%>&v1=<%=v1%>&v2=<%=v2%>"></iframe>



        <a id="selCovBoxBtn" data-toggle="modal" data-target="#selCovBoxDlg" style="display: none;">Open Modal</a>

        <!-- Modal -->
        <div id="selCovBoxDlg" class="modal fade" role="dialog">
            <div class="modal-dialog">

                <!-- Modal content-->
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                        <h4 class="modal-title">Select Coverage</h4>
                    </div>
                    <div class="modal-body">
                        <select size="12" class="form-control" id="selCovBox">
                            <option>Option 1</option>
                            <option>Option 2</option>
                            <option>Option 3</option>
                        </select>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" onclick="selCoverage();">OK</button>
                        <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
                    </div>
                </div>

            </div>
        </div>


        <!-- error dialog -->
        <div id='dlgError' class='modal'>
            <div class='modal-dialog' style="width: 400px">
                <div class='modal-content'>
                    <div class='modal-header'>
                        <button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>
                        <h5 class='modal-title'>Profiler</h5>
                    </div>
                    <form onsubmit="doRegister(event);">
                        <div class='modal-body'>
                            <div id="error-msg"></div>
                        </div>
                        <div class='modal-footer'>
                            <button type='button' class='btn' data-dismiss='modal' style="width: 80px" onclick="onErrorClose();">Close</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>




    </form>
</body>
</html>
