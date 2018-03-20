<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="profiler.main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title><%=title%></title>

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

        body {
            padding-right: 10px;
        }
    </style>

    <%
        
        if (Session["bbox_x1"] == null)
        {
            mainFrameSource = "selarea.aspx?caption=" + Server.UrlEncode("Select area of interest");
        }
            
        
        
        
        
    %>

    <script type="text/javascript">

        var global = {
            pageIndex: 1,
            pageList: []
        };


        function resizeIFrames() {
            var offset = 0;
            var cy = $(window).height();
            var cx = $(window).width();
            $('.pageFrame').height(cy - (90 - offset));
        }



        $(document).ready(function () {
            $(window).on('resize', resizeIFrames);
            $('#indicatorFrame').hide();
            resizeIFrames();
            initPageButtons();

            $('.proflink').click(function (evt) {
                evt.preventDefault();
                var title = $(this).html();
                var href = $(this).attr('href');
                addPage(title, href);
            });
           
        });

        function initPageButtons() {
            $('.pageButton').off();
            $('.pageButton').click(function () {
                $('.pageButton').removeClass('active');
                $('#' + this.id).addClass('active');
                $('.pageFrame').hide();
                $('#' + this.id.substr(4)).show();
                global.pageList.push(this.id);
            })
        }

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

        function CloseAllPages() {
            var pages = [];
            for (var i = 0; i < global.pageList.length; i++) {
                if (pages.indexOf(global.pageList[i]) == -1)
                    pages[global.pageList[i]] = {};
            }
            for (var page in pages) {
                if (page != 'btn_mainFrame')
                    closePage(page);
            }
            $('#btn_mainFrame').trigger('click');

        }

        function closePage(id) {
            // remove button
            $('#btn_' + id).remove();
            // remove iframe
            $('#' + id).remove();
            // select home
            
            // remove from page list
            debugger;
            var btn = 'btn_' + id;

            for (; ;) {
                var index = global.pageList.indexOf(btn);
                if (index == -1)
                    break;
                global.pageList.splice(index, 1);
            }

            if (global.pageList.length > 0) {
                var page = global.pageList[global.pageList.length - 1];
                $('#' + page).trigger('click');
            }
            else {
                $('#btn_mainFrame').trigger('click');
            }
        }


        function addPage(title, url, icon) {
            var pageID = 'page_' + global.pageIndex++;
            if (icon == null)
                icon = 'glyphicon-tasks';

            

            var button = '<li id="btn_' + pageID + '" class="pageButton"><a href="#"><span class="glyphicon ' + icon + '" aria-hidden="true"></span>&nbsp;' + title + '&nbsp;<span class="glyphicon glyphicon glyphicon-remove" style="cursor: pointer" aria-hidden="true" onclick="closePage(\'' + pageID + '\');"></span></a></li>';
            $('#navbarmain').append($(button));

            url += '&frameid=' + pageID;
            var iframe = '<iframe class="pageFrame" id="' + pageID + '" name="' + pageID + '" src="' + url + '" style="border: 0px solid #f0f0f0; width: 100%"></iframe>';
            $('#iframes').append($(iframe));


            initPageButtons();
            resizeIFrames();

            $('#btn_' + pageID + '').trigger('click');
        }



    </script>
</head>
<body style="padding-left: 10px; overflow-x: hidden; overflow-y: hidden">
    <form id="form1" runat="server">


        <!-- Static navbar -->
        <nav class="navbar navbar-inverse">
        <div class="container-fluid">
          <div class="navbar-header">
            <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar" aria-expanded="false" aria-controls="navbar">
              <span class="sr-only">Toggle navigation</span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
              <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="main.aspx"><%=title%></a>
          </div>
          <div id="navbar" class="navbar-collapse collapse">
            <ul class="nav navbar-nav" id="navbarmain">
              <li id="btn_mainFrame" class="pageButton active"><a href="#"><span class="glyphicon glyphicon-home" aria-hidden="true"></span>&nbsp;Home</a></li>
              <li role="separator" class="divider"></li>
            </ul>
            <ul class="nav navbar-nav navbar-right">
              <li class="dropdown">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-cog" aria-hidden="true"></span>&nbsp;Tools <span class="caret"></span></a>
                <ul class="dropdown-menu">
                  <!--<li><a class="proflink" href="selarea.aspx" id="selfeaturebtn">Select area of interest</a></li>-->
                    <li role="separator" class="divider"></li>
                  <li><a href="#">Open Profile</a></li>
                    <li role="separator" class="divider"></li>
                  <li><a href="#">Save Profile</a></li>
                  <li><a href="#">Embed Profile</a></li>
                </ul>
              </li>
            </ul>
          </div><!--/.nav-collapse -->
        </div><!--/.container-fluid -->
      </nav>

        <!-- Main component for a primary marketing message or call to action -->
        <div id="iframes">
            <iframe class="pageFrame" id="mainFrame" name="mainFrame" src="<%=mainFrameSource%>" style="border: 1px solid #f0f0f0; width: 100%"></iframe>
        </div>
        


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
