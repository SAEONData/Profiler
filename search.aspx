<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="search.aspx.cs" Inherits="profiler.search" %>
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

    
    <link href="Content/jquery.scrolling-tabs.css" rel="stylesheet" />

    <script type="text/javascript" src="Scripts/jquery.scrolling-tabs.js"></script>

    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?v=3&key=AIzaSyBd07P0gb_cNMvMC74VMbNFy9ogx7iFkF4"></script> 


    <style type="text/css">
        .tabBody {
            background-color: white;
            border-left: 1px solid #dddddd;
            border-right: 1px solid #dddddd;
            border-bottom: 1px solid #dddddd;
            padding: 10px;
        }

        .tabbedControl {
            border: 1px solid #bbbbbb;
            border-radius: 4px;
            padding: 4px;
            width: 250px;
        }

        .acctab {
            padding-top: 2px;
            padding-left: 5px;
            padding-right: 6px;
        }
    </style>


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
    </style>

    <script type="text/javascript">

        function resizeGraphBox() {

            var offset = 0;

            var cy = $(window).height();
            var cx = $(window).width();
            $('#graphFrame').height(cy - (90 - offset));
            $('#searchFrame').height(cy - (90 - offset));

        }



        $(document).ready(function () {
            $(window).on('resize', resizeGraphBox);
            $('#searchFrame').hide();
            resizeGraphBox();

            $('.pageButton').click(function () {
                $('.pageButton').removeClass('active');
                $('#' + this.id).addClass('active');

                $('.pageFrame').hide();
                $('#' + this.id.substr(4)).show();
            })
        });

        function addDataSource(url) {
            parent.addDataSource(url);
        }

    </script>


</head>
<body style="padding-left: 10px; overflow-x: hidden; overflow-y: hidden">
    <form id="form1" runat="server">
      

    <div style="padding-left: 0px">
        <table class="table">
            <div class="row">
                <div class="<% WriteColumn1Classes(); %>" id="column1">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <div class="btn-group pull-right">
                                <span class="dropdown" id="quickFilterButton">
                                    <a class="dropdown-toggle" style="cursor: pointer" title="<% if (mode == "search") Response.Write("Search"); else Response.Write("Reports"); %> filters" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true"><i class="glyphicon glyphicon-filter" style="color: black"></i></a>
                                    <ul class="dropdown-menu" aria-labelledby="dropdownMenu1" id="quickFilterBox">
                                        <!--
                                        <li>
                                            &nbsp;&nbsp;<label>
                                                <input type="checkbox" class="" id="swSASDIOnly" onchange="doSearch(null);" />
                                                SASDI Metadata only
                                            </label>
                                        </li>
                                        -->
                                    </ul>                                
                                </span>
                                &nbsp;
                                <span id="searchAndEmbed">
                                    <% if (loggedIn == true) { %>
                                    <a onclick="saveSearch(); return false;" title="Save Search" href="#menu3"><i class="glyphicon glyphicon-floppy-save" style="color: black"></i></a>
                                    &nbsp;
                                    <a onclick="embedSearch(); return false;" title="Embed Search" href="#menu3"><i class="glyphicon glyphicon-save" style="color: black"></i></a>
                                    &nbsp;
                                    <% } %>
                                </span>
                                <a onclick="doClearAll(); return false;" title="Clear" href="#menu3"><i class="glyphicon glyphicon-remove-circle" style="color: black"></i></a>
                                &nbsp;
                                <a href="#" title="Hide <% if (mode == "search") Response.Write("search"); else Response.Write("report"); %> panel" onclick="hideControlPanel(); return false;"><span class="glyphicon glyphicon-chevron-left" aria-hidden="true" style="color: black"></span></a>
                            </div>
                            <% if (mode == "search") Response.Write("Search"); else Response.Write("Reports"); %>
                        </div>
                        <div class="panel-body" style="height: 620px;">


                            <div id="accordion" class="panel-group">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne">Simple Criteria</a>
                                        </h4>
                                    </div>
                                    <div id="collapseOne" class="panel-collapse collapse in">
                                        <div class="panel-body">
                                            <!-- panel simple -->
                                            <div class="input-group hidden">
                                                <label>
                                                    <input type="checkbox" class="" id="" />
                                                    SASDI Metadata only
                                                </label>
                                            </div>
                                            <div class="input-group">
                                                <form class="form-search" onsubmit="doSearch(event);">
                                                    <input type="text" class="form-control" placeholder="Any Text" id="textFilter" name="textFilter" value="<%=Request["anytext"] %>" />
                                                    <div class="input-group-btn textFilter">
                                                        <button id="mainSearchButton" class="btn btn-default" onclick="doSearch(event);" type="button"><i class="glyphicon glyphicon-search"></i></button>
                                                    </div>
                                                </form>
                                            </div>

                                            <fieldset id="repInstBoxFS">
                                                <label class="" style="font-weight: normal;">
                                                </label>
                                                <select class="form-control" id="repInstBox" onchange="doSearch(null);"  >
                                                    <option selected="selected" value="">Select Institution</option>
                                                    <% WriteInstitutions(); %>
                                                </select>
                                            </fieldset>

                                            <!-- end panel -->
                                        </div>
                                    </div>
                                </div>
                                <div class="panel panel-default"  id="AdvCritAcc">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">Advanced Criteria</a>
                                        </h4>
                                    </div>
                                    <div id="collapseTwo" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <!-- panel andvanced -->
                                            <ul class="nav nav-tabs nav-tabs-sm">
                                                <li class="active"><a data-toggle="tab" href="#menu2">When</a></li>
                                                <li><a data-toggle="tab" href="#menu1">What</a></li>
                                                <li><a data-toggle="tab" href="#home">Where</a></li>

                                                <li onclick="doSearch();" class="pull-right"><a title="Search" href="#menu3"><i class="glyphicon glyphicon-search" style="color: black"></i></a></li>
                                            </ul>

                                            <div class="tab-content tabBody" style="height: 400px">
                                                <div id="home" class="tab-pane acctab fade">
                                                    Show metadata records that are:
                                                    <br />
                                                    <select class="form-control" id="spatFilter" onchange="showSpatFilters();">
                                                        <option value=''>Do not filter</option>
                                                        <option value='contains'>Contained in</option>
                                                        <option value='intersects'>Overlapping with</option>
                                                        <option value='within'>Contains</option>
                                                    </select>
                                                    <br />
                                                    <div id="spatfilterbox">
                                                        The following polygon or bounding box:
                                                        <br />
                                                        <input type="button" class="btn btn-default btn-sm" style="width: 81px" value="Presets" onclick="doLocate();" />&nbsp;
                                                        <input type="button" class="btn btn-default btn-sm" style="width: 81px" value="Locate" onclick="doMapBox();" />&nbsp;
                                                        <input type="button" class="btn btn-default btn-sm" style="width: 81px" value="Clear" onclick="doClear();" />
                                                        <br />
                                                        <br />
                                                    

                                                        <div id="extentBoxBounds">
                                                            <div>
                                                                <span style="width: 50px; float: left; padding-top: 4px">Min X: </span>
                                                                <span>
                                                                    <input type="text" class="form-control" id="coordX1" /></span>
                                                            </div>
                                                            <div style="height: 13px;"></div>

                                                            <div>
                                                                <span style="width: 50px; float: left; padding-top: 4px">Min Y: </span>
                                                                <span>
                                                                    <input type="text" class="form-control" id="coordY1" /></span>
                                                            </div>
                                                            <div style="height: 13px;"></div>

                                                            <div>
                                                                <span style="width: 50px; float: left; padding-top: 4px">Max X: </span>
                                                                <span>
                                                                    <input type="text" class="form-control" id="coordX2" /></span>
                                                            </div>
                                                            <div style="height: 13px;"></div>

                                                            <div>
                                                                <span style="width: 50px; float: left; padding-top: 4px">Max Y: </span>
                                                                <span style="left: 300px">
                                                                    <input type="text" class="form-control" id="coordY2" /></span>
                                                            </div>
                                                        </div>
                                                        <div id="extentBoxGeom" class="">
                                                            Geometry:
                                                            <textarea class="form-control" style="height: 200px" id="extentWktBox"></textarea>
                                                            </fieldset>
                                                        </div>
                                                    </div>

                                                    <br />
                                                    <br />
                                                    <div class="row">
                                                        <form class="form-inline">
                                                            <div style="height: 10px"></div>
                                                            <div style="visibility: hidden">
                                                                <div style="height: 10px"></div>
                                                                <fieldset>
                                                                    <label class="" style="font-weight: normal;">
                                                                        <div style="width: 86px">Preselect:</div>
                                                                    </label>
                                                                    <input type="text" class="form-control" />
                                                                </fieldset>
                                                            </div>
                                                        </form>
                                                    </div>

                                                </div>
                                                <div id="menu1" class="tab-pane acctab fade">

                                                    <!-- hidden div -->
                                                    <div class="hidden">
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Record ID:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swRecordID" />
                                                        </fieldset>
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Title:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swTitle" />
                                                        </fieldset>
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Abstract:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swAbstract" />
                                                        </fieldset>
                                                        <div style="height: 10px"></div>
                                                    </div>

                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Keywords:</div>
                                                        </label>
                                                        <input type="text" class="form-control" id="swKeywords" value="<%=Request["subjects"]%>" />
                                                    </fieldset>

                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Author:</div>
                                                        </label>
                                                        <input type="text" class="form-control" id="swAuthor" />
                                                    </fieldset>
                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Institution:</div>
                                                        </label>
                                                        <input type="text" class="form-control" id="swInstitution" value="<% GetValue("institution"); %>" />
                                                    </fieldset>
                                                    <div class="hidden">
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Type:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swType" />
                                                        </fieldset>
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Source:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swSource" />
                                                        </fieldset>
                                                        <div style="height: 10px"></div>
                                                        <fieldset>
                                                            <label class="" style="font-weight: normal;">
                                                                <div style="width: 86px">Link:</div>
                                                            </label>
                                                            <input type="text" class="form-control" id="swLink" />
                                                        </fieldset>
                                                    </div>

                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Other:</div>
                                                        </label>
                                                        <select class="form-control" onchange="selOtherBox();" id="otherBoxType">
                                                            <option value="spatrep">Spatial Representation Type</option>
                                                            <option value="refsys">Reference System</option>
                                                            <option value="sagdadFeatureType">SAGDaD Feature Type</option>
                                                        </select>
                                                    </fieldset>

                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Value:</div>
                                                        </label>

                                                        <div class="input-group box_other" id="box_spatrep">
                                                            <input type="text" class="form-control" id="spatRepType" onmousedown="doListDiaw('Select Spatial Representation Type', 'spatrep.js', setSpatRepType);" />
                                                            <span class="input-group-addon" id="Span3" style="cursor: pointer">
                                                                <span class="glyphicon glyphicon glyphicon-remove hidden" onclick="setSpatRepType('');" id="spatRepClearButton"></span>
                                                                <span class="glyphicon glyphicon-search" onclick="doListDialog('Select Spatial Representation Type', 'spatrep.js', setSpatRepType);"></span>
                                                            </span>
                                                        </div>

                                                        <input type="text" class="form-control box_other" id="box_refsys" />

                                                        <div class="input-group box_other" id="box_sagdadFeatureType">
                                                            <input type="text" class="form-control" id="sagdad" onmousedown="doListDialog('Select Feature Type', 'sagdad.js', setSAGDAD);" />
                                                            <span class="input-group-addon" id="Span2" style="cursor: pointer">
                                                                <span class="glyphicon glyphicon glyphicon-remove hidden" onclick="setSAGDAD('');" id="SagDADClearButton"></span>
                                                                <span class="glyphicon glyphicon-search" onclick="doListDialog('Select Feature Type', 'sagdad.js', setSAGDAD);"></span>
                                                            </span>
                                                        </div>



                                                    </fieldset>



                                                </div>
                                                <div id="menu2" class="tab-pane acctab fade in active">
                                                    <div class="<% if (mode == "report") { Response.Write(" hidden "); } %>">
                                                        Date to use:
                                                        <br />
                                                        <fieldset>
                                                            <select class="form-control" id="swWhenType" >
                                                                <option value="published">Published</option>
                                                                <option value="coverage">Data Time Range</option>
                                                                <option value="metadata">Metadata Date</option>
                                                            </select>
                                                        </fieldset>
                                                        <br />
                                                    </div>

                                                    Presets:
                                                    <br />
                                                    <a href="#" onclick="return genDate('ytd');">Year to date</a><br />
                                                    <a href="#" onclick="return genDate('cqt');">Current quarter</a><br />
                                                    <a href="#" onclick="return genDate('lqt');">Previous quarter</a><br />
                                                    <a href="#" onclick="return genDate('lcy');">Last calendar year</a><br />

                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">Start:</div>
                                                        </label>
                                                        <input type="text" placeholder="yyyy-mm-dd" class="form-control" style="padding-top: 0px; padding-bottom: 0px" id="swWhenStart" />
                                                    </fieldset>
                                                    <div style="height: 10px"></div>
                                                    <fieldset>
                                                        <label class="" style="font-weight: normal;">
                                                            <div style="width: 86px">End:</div>
                                                        </label>
                                                        <input type="text" placeholder="yyyy-mm-dd" class="form-control" style="padding-top: 0px; padding-bottom: 0px" id="swWhenEnd" />
                                                    </fieldset>
                                                </div>




                                            </div>
                                            <!-- end panel -->
                                        </div>
                                    </div>
                                </div>

                                <% if (Session["usr"] != null && Session["usr"] != "") { %>
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">
                                            <a data-toggle="collapse" data-parent="#accordion" href="#collapseThree">Saved <%=(mode == "search" ? "Searches" : "Reports") %></a>
                                        </h4>
                                    </div>
                                    <div id="collapseThree" class="panel-collapse collapse">
                                        <div class="panel-body">
                                            <div id="menu3">
                                                <ul class="nav nav-pills nav-stacked" style="height: 120px; overflow-y: auto; border: 1px solid #f0f0f0" id="Ul1">
                                                    <li><a onclick="stockSearch('author');">My Metadata</a></li>
                                                    <li><a onclick="stockSearch('institution');">My Institution's Metadata</a></li>
                                                    <li><a onclick="stockSearch('parentchild');">My Parent Institution's  Metadata</a></li>
                                                    <!--<li><a onclick="stockSearch('parentchild');">My Parent Institution's Children's Metadata</a></li>-->
                                                </ul>
                                                <br />
                                                <strong>My Saved <%=(mode == "search" ? "Searches" : "Reports") %>:</strong>
                                                <ul class="nav nav-pills nav-stacked" style="height: 250px; overflow-y: auto; border: 1px solid #f0f0f0" id="ssbox">
                                                </ul>
                                            </div>
                                            <br />
                                            <!--
                                            <input type="button" class="btn btn-default btn-sm" style="width: 112px" value="Save" onclick="saveSearch();" />&nbsp;&nbsp;
                                            <input type="button" class="btn btn-default btn-sm" style="width: 112px" value="Embed" onclick="embedSearch();" />&nbsp;&nbsp;
                                            -->
                                        </div>
                                    </div>
                                </div>


                                <% } %>
                            </div>
                        </div>
                    </div>
                    <% if (Session["usr"] != null && Session["usr"] != "" && Request["atlas"] != "true") { %>
                    <% } %>
                </div>

                <div class="<% WriteColumn2Classes();%>" id="column2">

                    <div class="scrolling-tabs-container">
                        <!-- Nav tabs -->
                        <span class="pull-left hidden" aria-hidden="true" style="padding-top: 7px; padding-left: 7px; padding-right: 7px" id="SCPLBox">
                            <a href="#" title="Show control panel" onclick="showControlPanel(); return false;"><span class="glyphicon glyphicon-chevron-right" style="color: black"></span></a>
                        </span>
                        <ul class="nav nav-tabs nav-tabs-sm scrolling-tabs" role="tablist" id="restabs">
                            <li role="presentation" class="active hidden"><a href="#tabSearch" aria-controls="tabSearch" role="tab" id="extentTab" data-toggle="tab">Extent</a></li>
                        </ul>

                        <!-- Tab panes -->
                        <div class="tab-content">
                            <div role="tabpanel" class="tab-pane tabBody active" id="tabSearch">
                                <div id="mapframe" name="mapframe" style="width: 100%; padding-left: 8px; padding-top: 8px; height: <%=frameHeight%>px; border: 1px solid #dddddd; overflow-y: hidden; border-radius: 3px; " src="">
                                    <a href="#" onclick="viewDetails(&quot;3860ca45fca3ac06b6865159040865c9&quot;); return false;">the rasdaman raster array database – rasdaman</a><br>
                                    rasdaman ("raster data manager") allows storing and querying massive multi-dimensional ​arrays, such as sensor, image, simulation, and statistics data ...
                                    <br>
                                    <div style="height: 10px"></div>
                                    <button type="button" class="btn btn-default btn-sm" style="" onclick="viewMetadata(&quot;3860ca45fca3ac06b6865159040865c9&quot;);"><span class="glyphicon glyphicon-list-alt" aria-hidden="true"></span>&nbsp;View Metadata</button>&nbsp;
                                    <button type="button" class="btn btn-default btn-sm" style="" onclick="addDataSource('http://ows.rasdaman.org/rasdaman/ows');"><span class="glyphicon glyphicon-save" aria-hidden="true"></span>&nbsp;Add to Profile</button>&nbsp;
                                    <br />

                                </div>
                            </div>
                        </div>
                    </div>
                </div>

        </table>
    </div>
    <script type="text/javascript">

        var global = {};
        global.searchTabs = false;

        var extentMap = {};


        function isFrameVisible(id) {
            return $('#' + id).is(':visible');
        }

        function showSpatFilters() {
            var val = $('#spatFilter').val();
            if (val == '') {
                $('#spatfilterbox').hide();
            }
            else {
                $('#spatfilterbox').show();
            }
        }

        function showSearchTabs() {

            if (global.searchTabs == false) {
                global.searchTabs = true;
                var mode = '<%=mode%>';


                if (mode == 'search') {
                    $('#restabs').append('<li role="presentation"><a id="btnAnalysis" href="#tabAnalysis" aria-controls="tabAnalysis" role="tab" data-toggle="tab">Result Summary</a></li>');
                    $('#restabs').append('<li role="presentation"><a id="btnMap" href="#tabMap" aria-controls="tabMap" role="tab" data-toggle="tab">Map</a></li>'); // onclick="initAnalMap();"
                    $('#restabs').append('<li role="presentation"><a id="btnResults" href="#tabResults" aria-controls="tabResults" role="tab" data-toggle="tab">Listing</a></li>');

                    $('#btnMap').click(initAnalMap);
                }
                else {
                }
            }

            $('#btnResults').trigger('click');
            $('#btnAnalysis').trigger('click');
        }

        function genDate(type) {

            var d = new Date();
            var quarter = Math.floor((d.getMonth() / 3));

            var start = null;
            var end = new Date();
            if (type == 'ytd') {
                start = new Date(new Date().getFullYear(), 0, 1);
            }
            if (type == 'cqt') {
                var firstDate = new Date(d.getFullYear(), quarter * 3, 1);
                start = firstDate;
                end = new Date(firstDate.getFullYear(), firstDate.getMonth() + 3, 0);
            }
            if (type == 'lqt') {
                var firstDate = new Date(d.getFullYear(), quarter * 3 - 3, 1);
                start = firstDate;
                end = new Date(firstDate.getFullYear(), firstDate.getMonth() + 3, 0);
            }
            if (type == 'lcy') {
                start = new Date(d.getFullYear() - 1, 0, 1);
                end = new Date(d.getFullYear() - 1, 11, 31);
            }

            if (start != null)
                $('#swWhenStart').datepicker('setDate', start);
            if (end != null)
                $('#swWhenEnd').datepicker('setDate', end);





            return false;
        }

        function replaceAll(str, find, replace) {
            return str.replace(new RegExp(find, 'g'), replace);
        }

        function addItemToAtlas(id) {
            parent.addItemToAtlas(id);
        }



        function BuildSearchURL() {

            var mode = '<%=mode%>';
            var atlas = '<%=Request["atlas"]%>';
            if (mode == 'search')
                var url = 'sresults.aspx?text=' + escape($('#textFilter').val());
            else
                var url = 'sreport.aspx?text=' + escape($('#textFilter').val());

            if (mode == 'report') {
                url += '&institution=' + escape($("#repInstBox option:selected").text()); // $('#repInstBox').val();
            }
            else {
                url += '&atlas=' + atlas;
                url += '&sasdiOnly=' + $('#swSASDIOnly').is(':checked');
                url += '&recordID=' + $('#swRecordID').val();
                url += '&title=' + $('#swTitle').val();
                url += '&abstract=' + $('#swAbstract').val();
                url += '&keywords=' + $('#swKeywords').val();
                url += '&author=' + $('#swAuthor').val();

                url += '&fmspectype=' + $('#otherBoxType').val();
                url += '&fmspecvalue=' + $('#sagdad').val();

                url += '&institution=' + $('#swInstitution').val();
                url += '&type=' + $('#swType').val();
                url += '&source=' + $('#swSource').val();
                url += '&link=' + $('#swLink').val();
                url += '&whenType=' + $('#swWhenType').val();
                url += '&whenStart=' + $('#swWhenStart').val();
                url += '&whenEnd=' + $('#swWhenEnd').val();

                var filter = $('#spatFilter').val();
                if (filter != '') {
                    var wkt = $('#extentWktBox').val();
                    if (wkt == '') {
                        wkt = 'POLYGON((x1 y1, x2 y1, x2 y2, x1 y2, x1 y1))';
                        wkt = replaceAll(wkt, 'x1', $('#coordX1').val());
                        wkt = replaceAll(wkt, 'y1', $('#coordY1').val());
                        wkt = replaceAll(wkt, 'x2', $('#coordX2').val());
                        wkt = replaceAll(wkt, 'y2', $('#coordY2').val());
                    }
                    url += '&filter=' + escape(filter);
                    url += '&wkt=' + escape(wkt);
                }
            }

            return url;
        }

        function setPageUrl(frame, url) {
            debugger;
            var base = $('#' + frame).attr('name');
            if (base == null || base == '') {
                base = $('#' + frame).attr('src');
                $('#' + frame).attr('name', base);
            }
            $('#' + frame).attr('src', url.replace('sreport.aspx', base));
        }

        function doClearAll() {
            location.reload();
        }

        function doSearch(event) {
            $('#searchAndEmbed').show();
            if (event && event.preventDefault != null)
                event.preventDefault();
            var url = BuildSearchURL();

            masterLog(evSearchPerformed, '', url);

            var mode = '<%=mode%>';

            if (mode == 'search') {
                $('#anlframe').attr('src', url + '&mode=analysis');
                $('#resframe').attr('src', url + '&mode=results');


                var mapurl = url + '&mode=analysis';
                mapurl = mapurl.replace('sresults.aspx', 'scluster.aspx');

                $('#ampframe').attr('src', mapurl);

                showSearchTabs();
            }
            else {

                setPageUrl('frmMetaDataStatus', url);
                setPageUrl('frmHarvesters', url);
                setPageUrl('frmUsers', url);
                setPageUrl('frmCmtAndRat', url);
                setPageUrl('frmSearches', url);
                setPageUrl('frmDownloads', url);
                setPageUrl('frmEmbedding', url);
                setPageUrl('frmComposites', url);
                setPageUrl('frmStatistics', url);

                /*
                $('#frmStatus').attr('src', url + '&mode=status');
                $('#frmRatings').attr('src', url + '&mode=ratings');
                $('#frmUsage').attr('src', url + '&mode=usage');
                $('#frmStatistics').attr('src', url + '&mode=statistics');
                */
            }



        }

        function doMapBox() {
            $('#dlgMapBox').modal()
            setTimeout("initMap();", 200);
        }

        var smapinit = false;


        function initMap() {
            debugger;
            if (smapinit == false) {

                extentMap.map = new google.maps.Map(document.getElementById('map-sel-canvas'), {
                    zoom: 5,
                    center: { lat: -29, lng: 25 }
                });

                var parliament = new google.maps.LatLng(-29, 25);
                extentMap.marker = new google.maps.Marker({
                    map: null,
                    draggable: true,
                    animation: google.maps.Animation.DROP,
                    position: parliament
                });


                var bounds = {
                    north: -26.00,
                    south: -30.00,
                    west: 24.00,
                    east: 28.00,

                };

                // Define a rectangle and set its editable property to true.
                extentMap.rectangle = new google.maps.Rectangle({
                    map: extentMap.map,
                    bounds: bounds,
                    editable: true,
                    draggable: true,
                });

                smapinit = true;

            }
        }

        function updateCoords() {
            $('#extentBoxGeom').hide();
            $('#extentBoxBounds').show();
            var ne = extentMap.rectangle.getBounds().getNorthEast();
            var sw = extentMap.rectangle.getBounds().getSouthWest();
            $('#coordX1').val(sw.lng());
            $('#coordY2').val(sw.lat());
            $('#coordX2').val(ne.lng());
            $('#coordY1').val(ne.lat());
            if ($('#spatFilter').val() == '' || $('#spatFilter').val() == 'None')
                $('#spatFilter').val('intersects');
            showSpatFilters();
            doSearch();
        }


        function setCoverageType(type) {
            window.frames["smapbox"].setCoverageType(type);

        }




        function initAnalMap() {
            if (window.frames['ampframe'].initialize == null) {
                setTimeout(initAnalMap, 200);
                return;
            }
            window.frames['ampframe'].initialize();
        }

    </script>

    <!-- extent dialog -->
    <div id='dlgExtentLookup' class='modal fade'>
        <div class='modal-dialog'>
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>
                    <h4 class='modal-title' id="selListTitle">Extent</h4>
                </div>
                <div class='modal-body'>
                    <div class="input-group">
                        <select class="form-control" id="extSelBox" style="width: 540px; border-radius: 3px">
                            <option>Provinces</option>
                            <option>Bions</option>
                        </select>
                    </div>
                    <div style="height: 10px"></div>
                    <div class="input-group">
                        <input type="text" class="form-control" placeholder="Search" id="extentSearch" name="textFilter" value="" onkeyup="doExtentFilter();" onchange="doExtentFilter();" />
                        <div class="input-group-btn textFilter">
                            <button class="btn btn-default" type="submit"><i class="glyphicon glyphicon-search" onclick="doExtentFilter();"></i></button>
                        </div>
                    </div>
                    <div style="height: 10px"></div>
                    <div style="border: 0px solid green; height: 300px; overflow-y: auto; padding-right: 10px">
                        <table class="table">
                            <tr>
                                <td>Name</td>
                            </tr>
                            <tbody id="extenttb"></tbody>
                        </table>
                    </div>
                </div>

                <div class='modal-footer'>
                    <button type='button' class='btn' data-dismiss='modal' style="width: 80px">Cancel</button>
                </div>
            </div>
        </div>
    </div>

    <!-- map dialog -->
    <div id='dlgMapBox' class='modal fade'>
        <div class='modal-dialog' style="width: 700px">
            <div class='modal-content'>
                <div class='modal-header'>
                    <button type='button' class='close' data-dismiss='modal'><span aria-hidden='true'>&times;</span><span class='sr-only'>Close</span></button>
                    <h4 class='modal-title'>Select Extent</h4>
                </div>
                <form onsubmit="doRegister(event);">
                    <div class='modal-body'>
                        <table class="hidden">
                            <tr>
                                <td style="width: 140px">Coverage Type:
                                </td>
                                <td style="width: 500px">
                                    <select id="Select2" class="form-control" onchange="setCoverageType(this.value);">
                                        <option value="rect">Bounds</option>
                                        <option value="point">Point</option>
                                    </select>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 140px">Coordinates:
                                </td>
                                <td style="width: 500px">
                                    <input type="text" class="form-control" id="mapCoords" />
                                </td>
                            </tr>
                        </table>
                        <div id="map-sel-canvas" style="width: 100%; height: 360px; border: 1px solid #e0e0e0"></div>
                    </div>
                    <div class='modal-footer'>
                        <button type='button' class='btn btn-default' data-dismiss='modal' style="width: 80px" onclick="updateCoords();">Ok</button>
                        <button type='button' class='btn btn-default' data-dismiss='modal' style="width: 80px">Cancel</button>
                    </div>
                </form>
            </div>
        </div>
    </div>




    <script type="text/javascript">

        function focusSearchBox() {

        }




        function selectExtent(e, wkt) {
            e.preventDefault();
            $('#extentBoxBounds').hide();
            $('#extentBoxGeom').show();
            $('#extentWktBox').val(wkt);
            // window.frames['mapframe'].showWKT(wkt);
            $('#dlgExtentLookup').modal('toggle');
        }

        function doExtentFilter() {
            var val = $('#extSelBox').val();
            for (var i = 0; i < extents.length; i++) {
                var ext = extents[i];
                if (ext.name == val) {
                    $('#extenttb').html('');
                    var call = $.ajax({
                        url: "extents.aspx",
                        data: {
                            mode: 'list',
                            shape: ext.shape,
                            field: ext.field,
                            text: $('#extentSearch').val()
                        },
                        complete: function (res) {
                            var objects = $.parseJSON(res.responseText);
                            for (var i = 0; i < objects.length; i++) {
                                var obj = objects[i];
                                var code = '<tr><td><a style="cursor: pointer" name="' + obj.wkt + '" onclick="selectExtent(event, this.name);">' + obj.name + '</a></td></tr>'
                                $('#extenttb').append(code);


                            }


                            if (obj.success == false) {
                                error(obj.message);
                                return;
                            }
                        }
                    });
                }
            }
        }

        function focusSearchBox() {
            $('#extentSearch').focus();
        }

        var extentInit = false;

        function doClear() {
            debugger;

            clearSearch();
            // window.frames['mapframe'].clearAll();
        }


        function doLocate() {
            if (extentInit == false) {
                var ext = extents;
                $('#extSelBox').html('');
                for (var i = 0; i < extents.length; i++) {
                    var ext = extents[i];
                    $('#extSelBox').append('<option>' + ext.name + '</option>');
                }
                $('#extSelBox').change(doExtentFilter);
                doExtentFilter();
                extentInit = true;
            }
            $('#dlgExtentLookup').modal();
        }

        function resizeFrames() {
            var cy = $(window).height();
            var noframe = '<%=Request["noframe"]%>';

            if (noframe == 'true') {
                $('#anlframe').height(cy - 55);
                $('#ampframe').height(cy - 55);
                $('#resframe').height(cy - 55);
                if (window.frames['anlframe'].drawChart != null)
                    window.frames['anlframe'].drawChart();

            }

            var mode = '<%=mode%>';
            if (mode == 'report') {
                $('#AdvCritAcc').hide();
            }
            else {
                $('#repInstBoxFS').hide();
            }
        }

        $(document).ready(resizeFrames);
        $(window).resize(resizeFrames);


        function loadQuickFilters() {
            if (wizardPTInfrastructure == null || wizardPTInfrastructure.length == 0) {
                $('#quickFilterButton').hide();
            }
            else {
                $('#quickFilterButton').show();
                debugger;

                for (var i = 0; i < wizardPTInfrastructure.length; i++) {
                    var pitem = wizardPTInfrastructure[i];
                    var id = pitem.id = pitem.id.substr(2);

                    var code = '';
                    code += '<li>';
                    code += '&nbsp;&nbsp;<label>';
                    code += '<input type="checkbox" class="" id="sw' + id + 'Only" onchange="doSearch(null);" />';
                    code += '&nbsp;' + id + ' Metadata only';
                    code += '</label>';
                    code += '</li>';

                    $('#quickFilterBox').append(code);
                }


            }

        }


        $(document).ready(function () {
            debugger;

            $('#searchAndEmbed').hide();
            $('#extentBoxGeom').hide();
            selOtherBox();
            reloadSearches();
            loadQuickFilters();
            showSpatFilters();

            $('#mapframe').attr('src', portalConfig.searchHomeFrame);

            $('#restabs').scrollingTabs();

            // init date pickers
            var datePickerOptions = {
                format: 'yyyy-mm-dd',
                todayBtn: 'linked',
                todayHighlight: true,
                clearBtn: true,
                autoclose: true

            };
            $('#swWhenStart').datepicker(datePickerOptions);
            $('#swWhenEnd').datepicker(datePickerOptions);

            var inst = $('#swInstitution').val();
            if (inst != '')
                setTimeout(searchNow, 10);

            var anytext = '<%=Request["anytext"]%>';
            if (anytext != '')
                setTimeout(searchNow, 10);

            var mode = '<%=mode%>';
            if (mode == 'report') {
                showSearchTabs();
                var inst = '<% WriteDefaultInstitution(); %>';
                if (inst != '') {
                    $('#repInstBox').val(inst);
                    setTimeout(searchNow, 10);
                }
            }



            loadSearchURL();


        });

        var initLoad = false;

        function searchNow() {
            doSearch(null);
            <% if (hideControl == true ) { %>
            $('#extentTab').hide();
            <% } %>
        }

        function loadSearchURL() {
            debugger;
            if (initLoad == true)
                return;
            initLoad = true;
            var name = '<%=Request["load"]%>';
            if (name != '') {
                loadSearch(null, name);
                return;
            }

            var guid = '<%=Request["guid"]%>';
            if (guid != '') {
                loadSearch(null, guid, 'hidden');
                return;
            }

            var portal = masterGlobal.portal;
            if (portal == 'sasdi'); {
                $('#swSASDIOnly').attr('checked', true); // check with wim
                doSearch(null);
                $('#searchAndEmbed').hide();
            }

        }

        function setExtent(x1, y1, x2, y2) {

            $('#coordX1').val(x1);
            $('#coordY1').val(y2);
            $('#coordX2').val(x2);
            $('#coordY2').val(y1);
            // loadSearchURL();
        }

        function refineSearch(name, value) {

            $('#resframe').attr('src', 'loading.aspx');

            var url = BuildSearchURL();
            url += '&f_' + name + '=' + value;

            $('#resframe').attr('src', url + '&mode=results');


            $('#btnResults').trigger('click');
        }

        function saveSearch() {
            getItemName('Save <%=(mode == "search" ? "Search" : "Report") %>', 'Name', '', doSaveSearch);
        }

        function getReportJSON() {
            var search = {
                text: $('#textFilter').val(),
                sasdi: $('#swSASDIOnly').is(':checked'),
                where: {
                    wkt: $('#extentWktBox').val(),
                    bounds: {
                        x1: $('#coordX1').val(),
                        y1: $('#coordY1').val(),
                        x2: $('#coordX2').val(),
                        y2: $('#coordY2').val(),
                    },
                    filter: $('#spatFilter').val(),
                },
                what: {
                    recordID: $('#swRecordID').val(),
                    title: $('#swTitle').val(),
                    abstract: $('#swAbstract').val(),
                    keywords: $('#swKeywords').val(),
                    author: $('#swAuthor').val(),
                    institution: $('#swInstitution').val(),
                    type: $('#swType').val(),
                    source: $('#swSource').val(),
                    link: $('#swLink').val()
                },
                when: {
                    type: $('#swWhenType').val(),
                    before: $('#swWhenStart').val(),
                    after: $('#swWhenEnd').val()
                }
            };

            return search;

        }

        function doSaveSearch(name) {
            var search = getReportJSON();
            var type = '<%=mode%>';
            var call = $.ajax({
                url: "ajax.aspx",
                data: {
                    mode: 'save_string',
                    name: name,
                    type: type,
                    source: JSON.stringify(search, null, '\t')
                },
                complete: function (res) {
                    try {
                        var ret = $.parseJSON(res.responseText);
                        masterLog(evSearchSaved, ret.uid, JSON.stringify(search));
                        if (ret.success == true) {
                            reloadSearches();
                            error('<%=(mode == "search" ? "Search" : "Report") %> successfully saved');
                        }
                        else
                            error(ret.message);
                    }
                    catch (e) {
                        error('Failed to save search');
                    }
                }
            });
        }


        function embedSearch() {
            var name = genguid();
            var search = getReportJSON();
            var type = 'hidden';
            var call = $.ajax({
                url: "ajax.aspx",
                data: {
                    mode: 'save_string',
                    name: name,
                    type: type,
                    source: JSON.stringify(search, null, '\t')
                },
                complete: function (res) {
                    try {
                        var ret = $.parseJSON(res.responseText);
                        if (ret.success == true) {
                            var mode = '<%=mode%>';
                            var file = mode == 'search' ? 'search.aspx' : 'reports.aspx';
                            var location = document.location.href;
                            var index = location.indexOf(file);
                            if (index != -1)
                                location = location.substr(0, index);
                            var url = location + file + '?guid=' + name;
                            var options = { showFrameless: true };
                            masterLog(evEmbeddingCode, "", url);

                            getItemName('Embed <%=(mode == "search" ? "Search" : "Report") %>', 'URL', url, null, options);
                        }
                        else
                            error(ret.message);
                    }
                    catch (e) {
                        error('Failed to save search');
                    }
                }
            });



        }

        function clearSearch() {

            $('#restabs').html('<li role="presentation" class="active hidden"><a href="#tabSearch" aria-controls="tabSearch" role="tab" id="extentTab" data-toggle="tab">Extent</a></li>');
            $('#extentTab').trigger('click');

            $('#textFilter').val('');
            $('#swSASDIOnly').attr('checked', false);
            $('#extentWktBox').val('');
            $('#spatFilter').val('');
            showSpatFilters();
            $('#swRecordID').val('');
            $('#swTitle').val('');
            $('#swAbstract').val('');
            $('#swKeywords').val('');
            $('#swAuthor').val('');
            $('#swInstitution').val('');
            $('#swType').val('');
            $('#swSource').val('');
            $('#swLink').val('');
            $('#swWhenType').val('published');
            $('#swWhenStart').val('');
            $('#swWhenEnd').val('');
            // window.frames['mapframe'].clearAll();
            $('#extentBoxGeom').hide();
            $('#extentBoxBounds').show();
            // 
        }

        function doLoadSearch(json) {
            debugger;
            masterLog(evSearchLoaded, "", json);
            var search = $.parseJSON(json);
            if (search.success == false) {
                error(search.message);
                return;
            }

            clearSearch();
            $('#textFilter').val(search.text);
            $('#swSASDIOnly').attr('checked', search.sasdi);
            $('#extentWktBox').val(search.where.wkt);
            $('#coordX1').val(search.where.bounds.x1);
            $('#coordY1').val(search.where.bounds.y1);
            $('#coordX2').val(search.where.bounds.x2);
            $('#coordY2').val(search.where.bounds.y2);
            $('#spatFilter').val(search.where.filter);
            showSpatFilters();
            $('#swRecordID').val(search.what.recordID);
            $('#swTitle').val(search.what.title);
            $('#swAbstract').val(search.what.abstract);
            $('#swKeywords').val(search.what.keywords);
            $('#swAuthor').val(search.what.author);
            $('#swInstitution').val(search.what.institution);
            $('#swType').val(search.what.type);
            $('#swSource').val(search.what.source);
            $('#swLink').val(search.what.link);
            $('#swWhenType').val(search.when.type);
            $('#swWhenStart').val(search.when.before);
            $('#swWhenEnd').val(search.when.after);

            // window.frames['mapframe'].clearAll();
            if (search.where.wkt != '') {
                $('#extentBoxBounds').hide();
                $('#extentBoxGeom').show();
                // window.frames['mapframe'].showWKT(search.where.wkt);
            }
            else {
                $('#extentBoxGeom').hide();
                $('#extentBoxBounds').show();
            }

            var bounds = search.where.bounds;
            // window.frames['mapframe'].zoomToBounds(bounds.x1, bounds.y1, bounds.x2, bounds.y2);

            $('#mainSearchButton').trigger('click');

            setTimeout(function () {
                var tab = '<%=Request["tab"]%>';
                var ctl = 'btn' + tab;
                debugger;

                if (tab != '') {
                    $('#btn' + tab).trigger('click');
                }

            }, 200);
            }

            var searchBlocked = false;



            function loadSearch(e, name, mytype) {
                var type = '<%=mode%>';
            if (mytype != null)
                type = mytype;
            if (searchBlocked == true)
                return;
            if (e != null)
                e.preventDefault();
            var call = $.ajax({
                url: 'ajax.aspx?mode=loadsearch&name=' + name + "&type=" + type,
                complete: function (res) {
                    doLoadSearch(res.responseText);
                }
            });
        }

        function trashSearch(e, name) {
            var type = '<%=mode%>';
            e.preventDefault();
            searchBlocked = true;
            var call = $.ajax({
                url: 'ajax.aspx?mode=trashsearch&name=' + name + '&type=' + type,
                complete: function (res) {
                    reloadSearches()
                }
            });
        }

        function reloadSearches() {
            var type = '<%=mode%>';
            var call = $.ajax({
                url: 'ajax.aspx?mode=loadsearches&type=' + type,
                complete: function (res) {
                    $('#ssbox').html('');
                    var object = $.parseJSON(res.responseText);
                    var files = object.files;
                    if (files != null) {
                        for (var i = 0; i < files.length; i++) {
                            var file = files[i];
                            var code = '<li><a style="cursor:pointer" name="' + htmlEncode(file) + '" onclick="loadSearch(event, this.name);">' + htmlEncode(file) + '<span class="badge pull-right" style="cursor:pointer" title="Delete" onclick="trashSearch(event, \'' + htmlEncode(file) + '\');">x</span></a></li>';
                            $('#ssbox').append(code);
                        }
                    }
                    searchBlocked = false;
                }
            });
        }

        function setSAGDAD(text) {
            $('#sagdad').val(text);
            if (text != "")
                $('#SagDADClearButton').removeClass('hidden');
            else
                $('#SagDADClearButton').addClass('hidden');

        }

        function setSpatRepType(text) {
            $('#spatRepType').val(text);
            if (text != "")
                $('#spatRepClearButton').removeClass('hidden');
            else
                $('#spatRepClearButton').addClass('hidden');
        }

        function selOtherBox() {
            var type = $('#otherBoxType').val();
            $('.box_other').hide();
            $('#box_' + type).show();
        }

        function hideControlPanel() {
            $('#column1').hide();
            $('#column2').removeClass('col-md-8');
            $('#column2').addClass('col-md-12');
            $('#SCPLBox').removeClass('hidden');

            if (window.frames['anlframe'].drawChart != null)
                window.frames['anlframe'].drawChart();
        }

        function showControlPanel() {
            $('#column2').removeClass('col-md-12');
            $('#column2').addClass('col-md-8');
            $('#column1').show();
            $('#SCPLBox').addClass('hidden');

            if (window.frames['anlframe'].drawChart != null)
                window.frames['anlframe'].drawChart();


        }

        function stockSearch(type) {
            clearSearch();
            if (type == 'author')
                $('#swAuthor').val('<%=Session["full_name"]%>');
            if (type == 'institution')
                $('#swInstitution').val('<%=Session["inst_name"]%>');

            if (type == 'parent')
                $('#swInstitution').val('<%=parentInstitute%>');

            if (type == 'parentchild')
                $('#swInstitution').val('<%=parentInstitute%>|<%=childInstitutions%>');


            $('#mainSearchButton').trigger('click');


        }

    </script>

    


    </form>
</body>
</html>

