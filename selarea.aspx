<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="selarea.aspx.cs" Inherits="profiler.selarea" %>

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
            width: 100%;
        }

        body {
            padding-right: 10px;
        }


    </style>

    <script type="text/javascript">

        var global = {};


        function resizeGraphBox() {

            var offset = -60;

            var cy = $(window).height();
            var cx = $(window).width();
            $('#graphFrame').height(cy - (90 - offset));
            $('#searchFrame').height(cy - (90 - offset));
            $('#indicatorFrame').height(cy - (90 - offset));


        }



        $(document).ready(function () {
            $(window).on('resize', resizeGraphBox);
            $('#searchFrame').hide();
            $('#indicatorFrame').hide();
            resizeGraphBox();

            $('.pageButton').click(function () {
                $('.pageButton').removeClass('active');
                $('#' + this.id).addClass('active');

                $('.pageFrame').hide();
                $('#' + this.id.substr(4)).show();







            })

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

    </script>
</head>
<body style="padding-left: 10px; overflow-x: hidden; overflow-y: hidden">
    <form id="form1" runat="server">
        <p>
            <%=description%>
        </p>

        <% if (Request["caption"] != null && Request["caption"] != "") { %>
        <h4><%=Request["caption"]%></h4>
        <% } %>

        <ul class="nav nav-tabs">
          <li role="presentation" class="active" onclick="return false;"><a href="#" onclick="return false;">List</a></li>
          <li disabled="disabled" role="presentation" onclick="return false;"><a disabled="disabled" onclick="return false;" href="#" style="color: grey; cursor: no-drop">Map</a></li>
        </ul>

        <!-- Static navbar -->
        <nav class="navbar navbar-inverse" style="display: none">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
          </div>
          <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav">
              <li id="btn_graphFrame" class="pageButton active"><a href="#"><span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>&nbsp;List</a></li>
              <li id="btn_searchFrame" class="pageButton"><a href="#"><span class="glyphicon glyphicon-globe" aria-hidden="true"></span>&nbsp;Map</a></li>
            </ul>
          </div><!--/.nav-collapse -->
        </div><!--/.container-fluid -->
      </nav>

        <!-- Main component for a primary marketing message or call to action -->
        <iframe class="pageFrame" id="graphFrame" name="graphFrame" src="sa_list.aspx"></iframe>
        <iframe class="pageFrame" id="searchFrame" name="searchFrame" src="sa_map.aspx"></iframe>



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
