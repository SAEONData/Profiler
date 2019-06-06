<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="map.aspx.cs" Inherits="profiler.map" %>

<!DOCTYPE html>
<html>
<head>
    <title>Tiled WMS</title>
    <link rel="stylesheet" href="https://openlayers.org/en/v4.4.2/css/ol.css" type="text/css">
    <!-- The line below is only needed for old environments like Internet Explorer and Android 4.x -->
    <link href="Content/bootstrap.css" rel="stylesheet" />
    <link href="Content/bootstrap-responsive.css" rel="stylesheet" />
    <link href="Content/bootstrap-theme.css" rel="stylesheet" />
    <link href="Content/bootstrap-slider.css" rel="stylesheet" />
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <script type="text/javascript" src="Scripts/bootstrap.min.js"></script>
    <script type="text/javascript" src="Scripts/busyindicator.js"></script>

    <script src="https://cdn.polyfill.io/v2/polyfill.min.js?features=requestAnimationFrame,Element.prototype.classList,URL"></script>
    <script src="https://openlayers.org/en/v4.4.2/build/ol.js"></script>
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>
    <style type="text/css">
        html, body, #map {
            margin: 0;
            width: 100%;
            height: 100%;
            font-family: Arial;
            font-size: 11pt;
            color: #505050;
        }

        td {
            font-family: Arial;
            font-size: 10pt;
            color: #505050;
        }

        .trbox {
            width: 300px;
        }

        #info {
            position: absolute;
            z-index: 10;
            background-color: #ffffdd;
            border: 1px solid #ccc;
            color: #303030;
            padding: 5px;
            font-size: 14px;
            top: -10em;
            pointer-events: none;
        }

    </style>

    <script type="text/javascript">

        var wkt = '<%=feature.wkt%>';


        function resizeGraphBox() {
            var cy = $(window).height();
            var cx = $(window).width();
            $('#map').height(cy - 10);
        }


        $(document).ready(function () {


            $('.metalink').click(function (evt) {
                evt.preventDefault();
                var title = 'Metadata';
                var href = $(this).attr('href');
                parent.parent.addPage(title, href);
            });

        });

        function CheckLayer(id) {
            var checked = $('#cbvar' + id).is(':checked');
            var layer = id == 1 ? global.layer1 : global.layer2;
            if (checked) {
                $('#tbox' + id).attr('disabled', false);
                map.addLayer(layer);
            }
            else {
                $('#tbox' + id).attr('disabled', true);
                map.removeLayer(layer);
            }
        }

        function TransLayer(id) {
            var val = $('#tbox' + id).val();
            var layer = id == 1 ? global.layer1 : global.layer2;
            layer.setOpacity(val);
        }



    </script>

</head>
<body>
    <div id="info"></div>
    <div id="map" class="map">
    
        <div id="title" style="position: absolute; right: 20px; top: 20px; border: 1px solid #e0e0e0; border-radius: 5px; background-color: white; padding: 6px 6px 6px 6px; z-index: 99">
            <input type='checkbox' id='cbvar1' checked="checked" onchange="CheckLayer(1);" />
            <label for='cbvar1' title="<%=var1.path + var1.name%>"><%=truncate(var1.path + var1.name)%></label>
            <!--&nbsp;<a class="metalink" href="<%=var1.metalink%>" target="_blank" style="color: #303030"><i class="glyphicon glyphicon-option-vertical" onclick=""></i></a> -->
            <span class="dropdown">
              <img src="images/menu.png?v=2" class="dropdown-toggle" id="dropdownMenu1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer" />

              <ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
                <li><a href="<%=var1.metalink%>" class="metalink">View Metadata</a></li>
              </ul>
            </span>
            <br />
            <input type="range" class="trbox" min="0" max="1" step="0.01" id="tbox1" onchange="TransLayer(1);" />
            <% if (var1.note != null)
               {
                   Response.Write("<table>");
                   foreach (String key in var1.dict1.Keys)
                   {
                       Response.Write("<tr>");
                       Response.Write("<td style='width: 18px; background-color: " + key + "'>");
                       Response.Write("</td>");
                       Response.Write("<td>&nbsp;");
                       Response.Write(Server.HtmlEncode(var1.dict1[key]));
                       Response.Write("</td>");
                       Response.Write("</tr>");
                   }
                   Response.Write("</table>");
               } %>

            <% if (var2 != null) { %>
            <br />
            
            <input type='checkbox' id='cbvar2' checked="checked" onchange="CheckLayer(2);" />
            <label for='cbvar2' title="<%=var2.path + var2.name%>"><%=truncate(var2.path + var2.name)%></label>
            <span class="dropdown">
              <img src="images/menu.png?v=2" class="dropdown-toggle" id="Img1" data-toggle="dropdown" aria-haspopup="true" aria-expanded="true" style="cursor: pointer" />
              <ul class="dropdown-menu pull-right" aria-labelledby="dropdownMenu1">
                <li><a href="<%=var2.metalink%>" class="metalink">View Metadata</a></li>
              </ul>
            </span>

            <br />
            <input type="range" class="trbox" min="0" max="1" step="0.01" id="tbox2" onchange="TransLayer(2);" />
            <% if (var2.note != null)
               {
                   Response.Write("<table>");
                   foreach (String key in var2.dict1.Keys)
                   {
                       Response.Write("<tr>");
                       Response.Write("<td style='width: 18px; background-color: " + key + "'>");
                       Response.Write("</td>");
                       Response.Write("<td>");
                       Response.Write(Server.HtmlEncode(var2.dict1[key]));
                       Response.Write("</td>");
                       Response.Write("</tr>");
                   }
                   Response.Write("</table>");
               } %>



            <% } %>
        </div>

    </div>
    <script type="text/javascript">

        var global = {};
        var wms1 = '<%=var1.wmsurl%>';
        var layers1 = '<%=var1.wmslayers%>';
        var styles1 = '<%=var1.wmsstyles%>';

        var wms2 = '';
        var layers2 = '';
        var styles2 = '';

        <% if (var2 != null) { %>
            wms2 = '<%=var2.wmsurl%>';
            layers2 = '<%=var2.wmslayers%>';
            styles2 = '<%=var2.wmsstyles%>';
        <% } %>

        var layers = [
          new ol.layer.Tile({
              source: new ol.source.OSM()
          })
        ];



        if (wms1 != null) {
            var layer1 = new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url: wms1,
                    params: { 'LAYERS': layers1, 'TILED': true, 'STYLES': styles1 },
                    serverType: 'geoserver'
                })
            });
            layer1.setOpacity(0.5);
            global.layer1 = layer1;
            layers.push(layer1);
        }

        
        if (wms2 != null) {
            var layer2 = new ol.layer.Tile({
                source: new ol.source.TileWMS({
                    url: wms2,
                    params: { 'LAYERS': layers2, 'TILED': true, 'STYLES': styles2 },
                    serverType: 'geoserver'
                })
            });

            layer2.setOpacity(0.5);
            global.layer2 = layer2;
            layers.push(layer2);
        }

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
            target: 'map',
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

        var iconFeatures = [];

        var features = <%=features%>;
        debugger;
        for (var f in features) {
            var feat = features[f];

            var feature = new ol.Feature({
                id: feat.ProjectId,
                title: feat.ProjectTitle,
                geometry: new ol.geom.Point(ol.proj.transform([feat.LonCalculated, feat.LatCalculated], 'EPSG:4326', 'EPSG:900913')),
                
            });

            iconFeatures.push(feature);
        }

        var vectorSource = new ol.source.Vector({
            features: iconFeatures //add an array of features
        });

        var iconStyle = new ol.style.Style({
            image: new ol.style.Icon(({
                anchor: [16, 32],
                anchorXUnits: 'pixels',
                anchorYUnits: 'pixels',
                opacity: 1.0,
                src: 'images/mappin.png'
            }))
        });


        var vectorLayer = new ol.layer.Vector({
            source: vectorSource,
            style: iconStyle
        });

        map.addLayer(vectorLayer);

        // change mouse cursor when over marker
        var target = map.getTarget();
        var jTarget = typeof target === "string" ? $("#" + target) : $(target);
        $(map.getViewport()).on('mousemove', function (e) {
            var pixel = map.getEventPixel(e.originalEvent);
            var hit = false;
            map.forEachFeatureAtPixel(pixel, function (feature, layer) {
                if (feature.get('title') != null)
                    hit = true;
            });
            if (hit) {
                jTarget.css("cursor", "pointer");
            } else {
                jTarget.css("cursor", "");
            }
        });

        // add tooltip
        var info = document.getElementById('info');
        var target = document.getElementById('map');
        function displayFeatureInfo(pixel) {
            info.style.left = pixel[0] + 'px';
            info.style.top = (pixel[1] - 50) + 'px';
            var feature = map.forEachFeatureAtPixel(pixel, function(feature, layer) {
                return feature;
            });
            if (feature) {
                var text = feature.get('title');
                if (text != null) {
                    info.style.display = 'none';
                    info.innerHTML = text;
                    info.style.display = 'block';
                    target.style.cursor = "pointer";
                }
                else {
                    info.style.display = 'none';
                    target.style.cursor = "";
                }
            } else {
                info.style.display = 'none';
                target.style.cursor = "";
            }
        }

        // add click event
        map.on('pointermove', function(evt) {
            if (evt.dragging) {
                info.style.display = 'none';
                return;
            }
            var pixel = map.getEventPixel(evt.originalEvent);
            displayFeatureInfo(pixel);
        });

        map.on("click", function (e) {
            var id = null;
            var title = null;

            map.forEachFeatureAtPixel(e.pixel, function (feature, layer) {
                if (feature.get('id') != null) {
                    id = feature.get('id');
                    title = feature.get('title');
                }
            })

            if (id != null) { 
                var url = 'http://app01.saeon.ac.za/nccrdsite/#/projects/' + id + '?navbar=hidden';
                parent.parent.addPage(title, url);
            }
        })

    </script>
</body>
</html>
