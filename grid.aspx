<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="grid.aspx.cs" Inherits="profiler.grid" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Profiler</title>
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap.min.js"></script>
    <script type='text/javascript' src="Scripts/bootstrap-slider.js"></script>
    <script type="text/javascript" src="Scripts/busyindicator.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap-modal.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap-modalmanager.js"></script>

    <link rel="stylesheet" type="text/css" href="tooltipster/dist/css/tooltipster.bundle.min.css" />
    <link rel="stylesheet" type="text/css" href="tooltipster/dist/css/plugins/tooltipster/sideTip/themes/tooltipster-sideTip-light.min.css" />
    <script type="text/javascript" src="http://code.jquery.com/jquery-1.10.0.min.js"></script>
    <script type="text/javascript" src="tooltipster/dist/js/tooltipster.bundle.min.js"></script>
    

    <link rel="stylesheet" href="https://openlayers.org/en/v4.4.2/css/ol.css" type="text/css">
    <script src="https://openlayers.org/en/v4.4.2/build/ol.js"></script>



    <style type="text/css">

        table {
            border: 1px solid #e0e0e0;
        }

        

        .vertical-text {
            transform: rotate(90deg);
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
            font-family: Arial;
            font-size: 10pt;
        }

      

        a {
            color: blue;
            text-decoration: none;
        }


        .row-header {
            font-weight: normal;
        }

        .togglerSector {
            cursor: pointer;
            font-weight: normal;
        }

        .togglerDriver {
            cursor: pointer;
            font-weight: normal;
        }

        .disabled {
            background-color: #f0f0f0;
            cursor: no-drop;
        }

        .empty {
            text-align: center;
            background-color: white;
            cursor: pointer;
        }

        .spacer {
            display: inline-block;
            width: 20px;
        }

        .maintitle {
            font-weight: bold;
        }

        .vertHeader {
            color: #404040;
            padding-left: 6px;
            padding-top: 7px;
            padding-right: 7px;
            padding-bottom: 7px;

        }

        .vertLink {
            color: blue;
        }

        td {
            color: #404040;
            padding-left: 6px;
            padding-top: 7px;
            padding-right: 7px;
            padding-bottom: 7px;

        }

        .tooltip_templates { 
            
            height: 50px;

        }

        /*
        select {
            padding: 6px;
            border: 1px solid #e0e0e0;
            border-radius: 3px;
        }
        */

        .form-control {
            display: block;
            width: 100%;
            height: 34px;
            padding: 6px 12px;
            font-size: 14px;
            line-height: 1.42857143;
            color: #555;
            background-color: #fff;
            background-image: none;
            border: 1px solid #ccc;
            border-radius: 4px;
            -webkit-box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            box-shadow: inset 0 1px 1px rgba(0, 0, 0, .075);
            -webkit-transition: border-color ease-in-out .15s, -webkit-box-shadow ease-in-out .15s;
            -o-transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
            transition: border-color ease-in-out .15s, box-shadow ease-in-out .15s;
        }

    </style>

    <% if (rot == 1) { %>

    <style type="text/css">

        th.rotate {
          /* Something you can count on */
          height: 200px;
          white-space: nowrap;
          font-weight: normal;
        }

        th.rotate > div {
          transform: 
            /* Magic Numbers */
            translate(0px, 71px)
            /* 45 is really 360 - 45 */
            rotate(315deg);
            width: 22px;
        }
        th.rotate > div > span {
            padding-left: 6px;
            padding-top: 8px;
            padding-right: 7px;
            padding-bottom: 8px;
        }

    </style>
    <% } %>

    <% if (rot == 2) { %>
    <style type="text/css">

        th.rotate {
          /* Something you can count on */
          height: 225px;
          white-space: nowrap;
          font-weight: normal;
        }

        th.rotate > div {
          transform: 
            /* Magic Numbers */
            translate(0px, 107px)
            /* 45 is really 360 - 45 */
            rotate(270deg);
            width: 22px;
        }
        th.rotate > div > span {
          padding: 5px 5px;
        }

    </style>
    <% } %>


    <script type="text/javascript">


        function InitMap() {

            var layers = [
              new ol.layer.Tile({
                  source: new ol.source.OSM()
              })
            ];

            var wkt = '<%=feature.wkt%>';
            var format = new ol.format.WKT();
            var feature = format.readFeature(wkt, {
                dataProjection: 'EPSG:4326',
                featureProjection: 'EPSG:900913'
            });

            var style = new ol.style.Style({
                fill: new ol.style.Fill({
                    color: 'rgba(255, 255, 255, 0.0)'
                }),
                stroke: new ol.style.Stroke({
                    color: '#ff40ff',
                    width: 2
                })
            });

            var vector = new ol.layer.Vector({
                source: new ol.source.Vector({
                    features: [feature]
                }),
                style: style
            });

            layers.push(vector);

            var fMapCenterX = 26;
            var fMapCenterY = -28;
            var position = ol.proj.transform([fMapCenterX, fMapCenterY], 'EPSG:4326', 'EPSG:900913');

            var map = new ol.Map({
                layers: layers,
                target: 'themapdiv',
                view: new ol.View({
                    center: position,
                    zoom: 6
                })
            });


            var x1 = parseFloat('<%=feature.x1%>');
            var y1 = parseFloat('<%=feature.y1%>');
            var x2 = parseFloat('<%=feature.x2%>');
            var y2 = parseFloat('<%=feature.y2%>');
            var p1 = ol.proj.transform([x1, y1], 'EPSG:4326', 'EPSG:900913');
            var p2 = ol.proj.transform([x2, y2], 'EPSG:4326', 'EPSG:900913');
            var extent = ol.extent.boundingExtent([p1, p2]);

            var view = map.getView();
            view.fit(extent, map.getSize());

            map.once('postrender', function (event) {
                $('#ttbox').hide();
            });
        }




    </script>



    <script type="text/javascript">

        var global = {};
        global.levels = [];
        global.ideas = [];
        global.SectorTree = [];
        global.DriverTree = [];
        global.toggled = [];
        global.SectorTogglers = [];
        global.DriverTogglers = [];
        global.featureID = '<%=id%>';
        global.loadlist = [];
        global.loadindex = 0;

        global.filters = [];

        function findFilter(name) {
            for (var f in global.filters) {
                var filter = global.filters[f];
                if (filter.name == name)
                    return filter;
            }
            return null;
        }



        var featureID = '<%=id%>';






        $(document).ready(function () {
            loadJSON('<%=file%>');
            /*
            $('.tooltip').tooltipster({
                theme: 'tooltipster-light'
            });
            */
        });

        var key1 = '<%=rootStock%>';
        var key2 = '<%=rootDriver%>';

        function loadJSON(url) {
            $.ajax(url)
            .done(function (data) {
                var json = JSON.parse(data);
                var ideas = json.ideas;
                for (var i in ideas) {
                    var idea = ideas[i];
                    if (idea.title == key1) {
                        global.SectorRoot = idea;
                        global.maxSector = 0;
                        parseSectors(idea, 0);
                    }

                    if (idea.title == key2) {
                        global.DriverRoot = idea;
                        global.maxDriver = 0;
                        parseDrivers(idea, 0);
                    }
                    
                }

                global.filters.sort();
                for (var name in global.filters) {
                    $('#selFilter').append('<option>' + name + '</option>');
                }

                $('#selFilter').change(function () {
                    var name = $('#selFilter').val();
                    var filter = global.filters[name];
                    if (filter != null) {
                        var options = '<option value="*">Select Theme</option>';
                        filter.themes.sort();
                        for (var t in filter.themes) {
                            var theme = filter.themes[t];
                            options += '<option>' + theme + '</option>';
                        }
                        $('#selTheme').html(options);
                    }
                    else {
                        $('#selTheme').html('<option value="*">Select Theme</option>');
                    }
                    $('#selTheme').trigger('change');
                });

                $('#selTheme').change(function () {
                    loadTableTree();
                    InitMap();
                });




                $('#selFilter').trigger('change');


                
            })
            .fail(function (a, b, c) {
                alert("Failed to load json");
                return;
            })
        }

        function IsParentIdea(idea) {
            if (idea.ideas == null)
                return false;
            for (var i in idea.ideas) {
                return true;
            }
            return false;
        }

        function IsLeafIdea(idea) {
            return IsParentIdea(idea) == false;
        }

        function clearIdeas(root, parent) {
            root.collapsed = null;
            root.parent = parent;
            for (var i in root.ideas) {
                clearIdeas(root.ideas[i], root);
            }
        }

        function initFilters(root) {
            
            
            if (root.note && root.note.filters) {
//                if (root.title == 'Dams')
                root.filters = [];
                for (var f in root.note.filters) {
                    var filter = root.note.filters[f];
                    var name = filter.filtername;
                    if (root.filters[name] == null)
                        root.filters[name] = { name: name, themes: [] };

                    for (var i in filter.themes) {
                        var themes = filter.themes[i].split(',');
                        for (var t in themes) {
                            var theme = themes[t].trim();
                            if (root.filters[name].themes.indexOf(theme) == -1)
                                root.filters[name].themes.push(theme);
                        }
                    }
                }

                var current = root;
                var parent = root.parent;
                while (parent) {
                    if (parent.filters == null)
                        parent.filters = [];
                    for (var f in current.filters) {
                        var filter = current.filters[f];
                        var name = filter.name;
                        if (parent.filters[name] == null)
                            parent.filters[name] = { name: name, themes: [] };
                        for (var t in filter.themes) {
                            var theme = filter.themes[t];
                            if (parent.filters[name].themes.indexOf(theme) == -1)
                                parent.filters[name].themes.push(theme);
                        }
                    }

                    current = parent;
                    parent = parent.parent;
                }
            }

            for (var i in root.ideas) {
                initFilters(root.ideas[i]);
            }
        }

        function findIdea(id, root) {
            if (root.id == id)
                return root;
            for (var i in root.ideas) {
                var test = findIdea(id, root.ideas[i]);
                if (test != null)
                    return test;
            }
            return null;
        }

        function processIdea(idea) {
            var id = '' + idea.id;
            idea.id = id.replace('.', '_');
            if (idea.attr != null && idea.attr.note != null && idea.attr.note.text != null) {
                var text = idea.attr.note.text;
                var index = text.indexOf('{');
                if (index != -1) {
                    text = text.substr(index);
                    console.log("-----------------" + idea.title);
                    console.log(text);
                    var note = JSON.parse(text);
                    idea.note = note;

                    if (note.application != null)
                        idea.application = note.application;

                    if (note.filters != null) {
                        var filters = note.filters;
                        for (var f in filters) {
                            var filter = filters[f];

                            if (global.filters[filter.filtername] == null) {
                                global.filters[filter.filtername] = { themes: [] };
                            }
                            var globalFilter = global.filters[filter.filtername];


                            for (var t in filter.themes) {
                                var themes = filter.themes[t].split(',');
                                for (var x in themes) {
                                    var theme = themes[x].trim();
                                    if (globalFilter.themes.indexOf(theme) == -1)
                                        globalFilter.themes.push(theme);
                                }
                            }
                        }
                    }
                }
            }
            var note = idea.attr

            var index = idea.title.indexOf('http://');
            if (index == -1)
                index = idea.title.indexOf('https://');
            if (index != -1) {
                idea.link = idea.title.substr(index);
                idea.title = idea.title.substr(0, index);
                console.log(idea.link);
            }
        }

        function parseSectors(root, level) {

            processIdea(root);

            global.levels[level] = root.title;
            global.ideas[level] = root;
            var ideas = root.ideas;
            for (var i in ideas) {
                global.maxSector = Math.max(global.maxSector, level);
                var idea = ideas[i];

                var treeItem = {
                    ideas: []
                };
                var text = '';
                for (var n = 0; n <= level; n++) {
                    treeItem.ideas.push(global.ideas[n]);
                    text = global.levels[n];
                }


                treeItem.idea = idea;
                treeItem.name = text + '->' + idea.title;


                text += idea.title + ' (' + level + ')';

                global.SectorTree.push(treeItem);

                $('#deb').append(text + '<br>');

                parseSectors(idea, level + 1);
            }
        }

        function parseDrivers(root, level) {
            processIdea(root);
            global.levels[level] = root.title;
            global.ideas[level] = root;
            var ideas = root.ideas;
            for (var i in ideas) {
                global.maxDriver = Math.max(global.maxDriver, level);
                var idea = ideas[i];

                var treeItem = {
                    ideas: []
                };
                var text = '';
                for (var n = 0; n <= level; n++) {
                    treeItem.ideas.push(global.ideas[n]);
                    text = global.levels[n];
                    
                }

                treeItem.idea = idea;
                treeItem.name = text + '->' + idea.title;

                global.DriverTree.push(treeItem);

                $('#deb').append(text + '<br>');

                parseDrivers(idea, level + 1);
            }
        }

        function filterItem(item, filterName, filterTheme) {
            if (filterName != '*') {
                if (item.idea.filters == null)
                    return false;
                var filters = item.idea.filters;
                if (filters[filterName] == null)
                    return false;
                if (filterTheme != '*') {
                    if (filters[filterName].themes.indexOf(filterTheme) == -1)
                        return false;
                }
            }
            return true;
        }

        function getTextWidth(text, font) {
            // re-use canvas object for better performance
            var canvas = getTextWidth.canvas || (getTextWidth.canvas = document.createElement("canvas"));
            var context = canvas.getContext("2d");
            context.font = font;
            var metrics = context.measureText(text);
            return metrics.width;
        }

        


        function loadTableTree() {

            var filterName = $('#selFilter').val();
            var filterTheme = $('#selTheme').val();


            global.loadlist = [];
            global.DriverTogglers = [];
            global.SectorTogglers = [];
            global.loadindex = 0;

            clearIdeas(global.SectorRoot);
            clearIdeas(global.DriverRoot);

            initFilters(global.SectorRoot);
            initFilters(global.DriverRoot);
            


            // headers
            var code = '';


            code += '<tr>';
            code += '<th id="themapdiv"></th>';


            for (var i = 0; i < global.DriverTree.length; i++) {
                    
                var item = global.DriverTree[i];
                var colID = 'col_' + i;
                item.idea.colID = colID;
                if (filterItem(item, filterName, filterTheme) == true) {
                    // <th class="rotate">Column header 1</span></div></th>
                    code += '<th class="rotate ' + colID + '"><div><span>';
                    var title = item.idea.title.substr(0, 20);

                    for (var s = 1; s < item.ideas.length; s++)
                        code += '<div class="spacer">&nbsp;</div>'

                    if (IsParentIdea(item.idea)) {
                        code += '<b class="togglerDriver vertHeader" id="' + item.idea.id + '" title="' + item.idea.title + '" ></b>';
                        global.DriverTogglers.push(item.idea.id);
                    }
                    else {
                        var text = '' + item.idea.title;
                        if (text.length > 25)
                            text = text.substr(0, 25) + '...';

                        var title = '' + item.idea.title;
                        if (item.idea.application != null)
                            title = title + '\n' + item.idea.application;

                        code += '<a class="proflink vertHeader vertLink"  title="' + title + '" target="_blank" href="prof.aspx?id=' + global.featureID + '&v1=' + escape(item.idea.id) + '">' + text + '</a>';
                    }

                    code += '</span></div></th>';
                }

            }

            code += '</tr>';

            $('#tableHead').html(code);

            var profLinkIndex = 100;
            var bodyCode = '';

            
            for (var i = 0; i < global.SectorTree.length; i++) {
                var item = global.SectorTree[i];
                var rowID = 'row_' + i;

                code = '<tr " id="' + rowID + '">';

                if (filterItem(item, filterName, filterTheme) == true) {

                    item.idea.rowID = rowID;



                    code += '<td style="width: 420px; white-space: nowrap;">'

                    for (var n = 1; n < item.ideas.length; n++) {
                        code += '<div class="spacer">&nbsp;</div>'
                    }

                    var title = item.idea.title;
                    if (item.idea.application != null)
                        title = title + '\n' + item.idea.application;

                    if (IsParentIdea(item.idea)) {
                        code += '<b title="' + item.idea.title + '" class="togglerSector" id="' + item.idea.id + '" >' + item.idea.title; + '</b>';
                        global.SectorTogglers.push(item.idea.id);
                    }
                    else {
                        var text = '' + item.idea.title;
                        var truncated = false;
                        var max = 280;
                        while (getTextWidth(text, "arial 10pt") > max) {
                            truncated = true;
                            text = text.substr(0, text.length - 1);
                        }
                        if (truncated == true)
                            text = text.trim() + '...';

                        code += '<a class="horzHeader proflink" target="_blank" title="' + title + '" href="prof.aspx?id=' + global.featureID + '&v1=' + escape(item.idea.id) + '">' + text + '</a>';
                    }
                    code += '</td>'

                    for (var d = 0; d < global.DriverTree.length; d++) {
                        var driver = global.DriverTree[d];
                        if (filterItem(driver, filterName, filterTheme) == true) {
                            var cl = 'disabled';
                            var title = '';
                            var link = '';
                            var cellid = profLinkIndex++;
                            var frameid = '<%=Request["frameid"]%>';

                            if (IsLeafIdea(item.idea) && IsLeafIdea(driver.idea)) {
                                cl = 'empty';
                                title = item.idea.title + ' vs. ' + driver.idea.title;
                                link = 'prof.aspx?id=' + global.featureID + '&v1=' + item.idea.id + '&v2=' + driver.idea.id;
                                link += '&relframe=' + frameid;
                                link += '&cellid=' + cellid;
                            }


                            code += '<td id="td' + cellid + '" class="' + cl + ' ' + driver.idea.colID + '">'

                            if (link != '') {
                                var i1 = item.idea.title;
                                var i2 = driver.idea.title;
                                code += '<a id="pl' + cellid + '" class="proflink2" title="' + title + '" target="_blank" href="' + link + '">...</a>';

                                var url = 'grid.aspx?mode=loadSel';
                                url += '&fid=' + global.featureID;
                                url += '&i1=' + escape(item.idea.id);
                                url += '&i2=' + escape(driver.idea.id);
                                url += '&id=' + escape(cellid);

                                global.loadlist.push(url);

                                /*
                                $.ajax(url).complete(function (f) {
                                    if (f.responseText != "") {
                                        var args = f.responseText.split('|');
                                        var id = args[0];
                                        var val = args[1];
                                        var col = args[2];
                                        setCellVal(id, val, col);
                                    }
                                });
                                */
                            }


                            code += '</td>'
                        }


                    }

                    code += '</tr>'
                }

                bodyCode += code;
            }

            $('#tableBody').html(bodyCode);

            // setup click event
            $('.togglerSector').click(function () {
                toggleSector(this.id, false);
            });

            $('.togglerDriver').click(function () {
                toggleDriver(this.id, false);
            });


            $('.proflink').click(function (evt) {
                evt.preventDefault();
                var title = $(this).html();
                var href = $(this).attr('href');
                parent.addPage(title, href);
            });

            $('.proflink2').click(function (evt) {
                evt.preventDefault();
                var title = $(this).attr('title');
                var href = $(this).attr('href');
                parent.addPage(title, href);
            });


            // hide all togglers
            for (var t in global.SectorTogglers) {
                var id = global.SectorTogglers[t];
                toggleSector(id, true);
            }

            for (var t in global.DriverTogglers) {
                var id = global.DriverTogglers[t];
                toggleDriver(id, true);
            }

            loadNextURL();
        }

            function loadNextURL() {
                if (global.loadindex < global.loadlist.length) {
                    var url = global.loadlist[global.loadindex];
                    $.ajax(url).complete(function (f) {
                        if (f.responseText != "") {
                            var args = f.responseText.split('|');
                            var id = args[0];
                            var val = args[1];
                            var col = args[2];
                            setCellVal(id, val, col);
                        }
                        global.loadindex++;
                        loadNextURL();
                    });
                }
            }


            function hideChildren(root, init) {
                for (var i in root.ideas) {
                    var idea = root.ideas[i];
                    var id = idea.id;
                    $('#' + id).html('&#9658; ' + $('#' + id).attr('title'));
                    $('#' + idea.rowID).hide();
                    if (init == false)
                        idea.collapsed = true;
                    hideChildren(idea);
                }
            }

            function showChildren(root, init) {
                for (var i in root.ideas) {
                    var idea = root.ideas[i];
                    $('#' + idea.rowID).show();
                    if (idea.epanded == true)
                        showChildren(idea);
                }
            }


            function toggleSector(id, init) {
                var toggleidea = findIdea(id, global.SectorRoot);
                if (toggleidea) {
                    if (toggleidea.collapsed == null) {
                        toggleidea.collapsed = true;
                        $('#' + id).html('&#9658; ' + $('#' + id).attr('title'));
                        hideChildren(toggleidea, init);

                    }
                    else {
                        toggleidea.collapsed = null;
                        $('#' + id).html('&#9660; ' + $('#' + id).attr('title'));
                        showChildren(toggleidea);
                    }
                }

            }

            function hideChildrenDriver(root, init) {
                for (var i in root.ideas) {
                    var idea = root.ideas[i];
                    var id = idea.id;
                    $('#' + id).html('&#9654; ' + $('#' + id).attr('title'));
                    $('.' + idea.colID).hide();
                    if (init == false)
                        idea.collapsed = true;
                    hideChildrenDriver(idea);
                }
            }

            function showChildrenDriver(root, init) {
                for (var i in root.ideas) {
                    var idea = root.ideas[i];
                    $('.' + idea.colID).show();
                    if (idea.epanded == true)
                        showChildrenDriver(idea);
                }
            }


            function toggleDriver(id, init) {
                var toggleidea = findIdea(id, global.DriverRoot);
                if (toggleidea) {
                    if (toggleidea.collapsed == null) {
                        toggleidea.collapsed = true;
                        $('#' + id).html('&#9654; ' + $('#' + id).attr('title'));
                        hideChildrenDriver(toggleidea, init);

                    }
                    else {
                        toggleidea.collapsed = null;
                        $('#' + id).html('&#9660; ' + $('#' + id).attr('title'));
                        showChildrenDriver(toggleidea);
                    }
                }

            }

            function setCellVal(id, val, col) {
                $('#pl' + id).html(val);
                $('#td' + id).css('background-color', col);
            }

            var bb = {};

    </script>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table style="border: 0px; padding: 0px;">
            <tr>
                <td>
                    Filter Name:<br />
                    <select class="form-control" id="selFilter" style="width: 300px;">
                        <option value="*">Select Filter</option>
                    </select>
                </td>
                <td style="width: 10px;"></td>
                <td>
                    Theme:<br />
                    <select class="form-control" id="selTheme" style="width: 300px;">
                        <option value="*">Select Theme</option>
                    </select>
                </td>
            </tr>
        </table>
        <br />
        <!--
        <div style="font-weight: bold; color: #303030">
        Area of interest:<br />
        <span class="tooltip" data-tooltip-content="#tooltip_content" style=""><%=feature.name + "&nbsp;(" + feature.type + ")" %></span>
        </div>
        <div style="height: 2px"></div>

                
        <br />
        -->

        <table class="table table-header-rotated" border="1" style="border-collapse: collapse;">
          <thead id="tableHead">
          </thead>

          <tbody id="tableBody">

          </tbody>
        </table>

        <div id="deb" style="display: none"></div>


        <table class="table table-header-rotated" border="1" style="border-collapse: collapse; display: none">
          <thead>
            <tr>
              <!-- First column header is not rotated -->
              <th></th>
              <!-- Following headers are rotated -->
              <th class="rotate"><div><span>Column header 1</span></div></th>
                <th class="rotate"><div><span>Column header 2</span></div></th>
                <th class="rotate"><div><span>Column header 3</span></div></th>
                <th class="rotate"><div><span>Column header 4</span></div></th>
                <th class="rotate"><div><span>Column header 5</span></div></th>
                <th class="rotate"><div><span>Column header 6</span></div></th>
            </tr> 
            <tr>
              <!-- First column header is not rotated -->
              <th></th>
              <!-- Following headers are rotated -->
              <th class="rotate"><div><span>[o] Column header 1</span></div></th>
                <th class="rotate"><div><span>[o] Column header 2</span></div></th>
                <th class="rotate"><div><span>[o] Column header 3</span></div></th>
                <th class="rotate"><div><span>[o] Column header 4</span></div></th>
                <th class="rotate"><div><span>[o] Column header 5</span></div></th>
                <th class="rotate"><div><span>[o] Column header 6</span></div></th>
            </tr> 

          </thead>
          <tbody>
            <tr>
              <th class="row-header">Row header 1</th>
              <td><input checked="checked" name="column1[]" type="radio" value="row1-column1"></td>
              <td><input checked="checked" name="column2[]" type="radio" value="row1-column2"></td>
              <td><input name="column3[]" type="radio" value="row1-column3"></td>
              <td><input name="column4[]" type="radio" value="row1-column4"></td>
              <td><input name="column5[]" type="radio" value="row1-column5"></td>
              <td><input name="column6[]" type="radio" value="row1-column6"></td>
            </tr>
            <tr>
              <th class="row-header">Row header 2</th>
              <td><input name="column1[]" type="radio" value="row2-column1"></td>
              <td><input name="column2[]" type="radio" value="row2-column2"></td>
              <td><input checked="checked" name="column3[]" type="radio" value="row2-column3"></td>
              <td><input checked="checked" name="column4[]" type="radio" value="row2-column4"></td>
              <td><input name="column5[]" type="radio" value="row2-column5"></td>
              <td><input name="column6[]" type="radio" value="row2-column6"></td>
            </tr>
            <tr>
              <th class="row-header">Row header 3</th>
              <td><input name="column1[]" type="radio" value="row3-column1"></td>
              <td><input name="column2[]" type="radio" value="row3-column2"></td>
              <td><input name="column3[]" type="radio" value="row3-column3"></td>
              <td><input name="column4[]" type="radio" value="row3-column4"></td>
              <td><input checked="checked" name="column5[]" type="radio" value="row3-column5"></td>
              <td><input checked="checked" name="column6[]" type="radio" value="row3-column6"></td>
            </tr>
          </tbody>
        </table>

    
    </div>
    </form>
</body>
</html>
