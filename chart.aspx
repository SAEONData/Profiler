<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="chart.aspx.cs" Inherits="profiler.chart" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <script type="text/javascript" src="Scripts/jquery-2.1.3.js"></script>

    <title></title>



    <style type="text/css">
        body {
            font-family: Arial;
            font-size: 10pt;
            color: #303030;
        }


        table {
            border: 1px solid #303030;
        }

        th {
            font-weight: normal;
            color: #303030;
            padding-left: 5px;
            padding-top: 6px;
            padding-right: 6px;
            padding-bottom: 6px;
        }

        td {
            font-weight: normal;
            color: #303030;
            padding-left: 5px;
            padding-top: 6px;
            padding-right: 6px;
            padding-bottom: 6px;
        }

        label {
            cursor: pointer;
        }

        table {
            border: 1px solid #e0e0e0;
        }



        th.rotate {
            /* Something you can count on */
            height: 200px;
            white-space: nowrap;
            font-weight: normal;
        }

            th.rotate > div {
                transform:
                /* Magic Numbers */
                translate(0px, 92px)
                /* 45 is really 360 - 45 */
                rotate(270deg);
                width: 22px;
            }

                th.rotate > div > span {
                    padding: 5px 5px;
                }

        .bcell {
            text-align: center;
            cursor: pointer;
            color: white;
            text-shadow: 0px 0px 1px black;
        }

        .bcell_bold {
            font-weight: bold;
            border: 1px solid black;
        }
    </style>

</head>
<body>
    <% if (var2 == null || v != "")
       { %>
    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            $('#divimg').hide();
            $('#imgbtn').click(function (evt) {
                $('#divimg').show();
            });
        });

    </script>

    <% if (v != "")
       { %>


    <script type="text/javascript">

        google.charts.load('current', { packages: ['corechart', 'bar'] });
        google.charts.setOnLoadCallback(drawBasic);
        var items = '<%=Request["ids"]%>'.split(',');


            function drawBasic() {


                var var1Name = '<%=(v == "v1" ? var1.name : var2.name)%>';

            var data = google.visualization.arrayToDataTable([
                [var1Name
                      <%
           profiler.ProfVar v1 = v == "v1" ? var1 : var2;
           profiler.ProfVar v2 = v == "v1" ? var2 : var1;

           String[] indexes = Request["ids"].Split(',');
           List<string> columnNames = new List<string>();
           List<string> columns = new List<string>();

           foreach (String key in v2.dict2.Keys)
           {
               columnNames.Add(key);
           }

           string colors = "";

           foreach (String index in indexes)
           {
               String col = columnNames[int.Parse(index)];
               columns.Add(col);
               String color = v2.dict2[col];
               if (colors != "")
                   colors += ",";
               colors += "'" + color + "'";
           }

           foreach (String col in columns)
           {
               Response.Write(",'" + col + "'");
           }
                      %>
                , { role: 'style' }]
              <%
            

           
                       
            
           foreach (string key in v1.dicb.Keys)
           {
               String col = v1.dict2[key];
               Response.Write(",['" + key + "'");



               foreach (String c in columns)
               {
                   double val = 0;
                   if (v1.dicb[key].dict.ContainsKey(c))
                       val = v1.dicb[key].dict[c].count;
                   Response.Write("," + val);
               }

               String color = "#ff00ff";
               Response.Write(",''");
              

               Response.Write("]");
           }


              %>
            ]);

            var options = {
                title: var1Name,
                hAxis: {
                    format: '#.##%'
                },
                colors: [<%=colors%>],
                legend: {
                    // position: "none"
                }
            };

            var chart = new google.visualization.BarChart(document.getElementById('chart_div'));

            chart.draw(data, options);
        }

    </script>




    <% }
       else
       { %>

    <script type="text/javascript">

        google.charts.load('current', { packages: ['corechart', 'bar'] });
        google.charts.setOnLoadCallback(drawBasic);

        function drawBasic() {

            var var1Name = '<%=var1.name%>';

            var data = google.visualization.arrayToDataTable([
                [var1Name, 'Contribution', { role: 'style' }]
              <%
           foreach (string key in var1.dicb.Keys)
           {
               String col = var1.dict2[key];
               Response.Write(",['" + key + "', " + var1.dicb[key].count + ",'stroke-color: #404040; stroke-width: 1; fill-color: " + col + "']");
           }


              %>
            ]);

            var options = {
                title: var1Name,
                hAxis: {
                    format: '#.##%'
                },
                legend: {
                    position: "none"
                }
            };

            var chart = new google.visualization.BarChart(document.getElementById('chart_div'));

            chart.draw(data, options);
        }

    </script>

    <% } %>


    <div id="chart_div" style="width: 800px; height: 600px;"></div>
    <% }
       else
       { %>

    <script type="text/javascript">



        function enablePlotButton(enable) {
            var btn = $('#btnPlot');
            if (enable) {
                btn.removeClass('disabled');
            }
            else {
                btn.addClass('disabled');
            }
        }

        $(document).ready(function () {
            $('#divimg').hide();
            $('#imgbtn').click(function (evt) {
                $('#divimg').show();
            });

            $('.hcb').on('change', function () {
                $(".vcb").attr("checked", false);
                enablePlotButton($(this).is(':checked'));
            });

            $('.vcb').on('change', function () {
                $(".hcb").attr("checked", false);
                enablePlotButton($(this).is(':checked'));
            });


            $('.bcell').click(function () {
                $(this).toggleClass('bcell_bold');
                saveSelection($(this).attr('name'), $(this).hasClass('bcell_bold'));
           });


            enablePlotButton(false);

        });

        function saveSelection(name, selected) {
            var cols = name.split(',');
            var url = "chart.aspx?mode=savesel";
            url += "&grid=" + '<%=this.gridID%>';
            url += "&c1=" + escape(cols[0]);
            url += "&c2=" + escape(cols[1]);
            url += "&val=" + escape(cols[2]);
            url += "&sel=" + selected;
            $.ajax(url).complete(function (f) {
                if (f.responseText != "") {
                    var args = f.responseText.split('|');
                    var val = args[0];
                    var col = args[1];
                    var frame = parent.global.relframe;
                    var cell = parent.global.cellid;
                    parent.parent.frames[frame].setCellVal(cell, val, col);
                }
            });
        }

        function plotChart(v, ids) {

            var url = 'chart.aspx';
            url += '?id=' + '<%=id%>';
                url += '&v1=' + '<%=v1%>';
                url += '&v2=' + '<%=v2%>';
                url += '&v=' + v;
                url += '&ids=' + ids;

                return url;
            }


        function getChartURL() {

            var ids = [];

            $('.hcb').each(function (index) {
                var ctrl = $(this);
                if (ctrl.is(':checked')) {
                    ids.push(index);
                }
            });

            if (ids.length > 0) {
                return plotChart('v1', ids);
            }

            $('.vcb').each(function (index) {
                var ctrl = $(this);
                if (ctrl.is(':checked')) {
                    ids.push(index);
                }
            });

            if (ids.length > 0) {
                return plotChart('v2', ids);
            }

            return "chartinfo.aspx";
        };


    </script>



    <table border="1" style="border-collapse: collapse">
        <tr>
            <th>
                <!--<iframe src="chartbuttons.aspx" style="border: 0px solid red; width: 165px; height: 40px"></iframe>-->
            </th>
            <%
           Random rnd = new Random();
           int vb = 0;
           foreach (string key1 in var1.dict2.Keys)
           {
               Response.Write("<th class='rotate'><div><span><input type='checkbox' class='vcb' id='vb_" + vb + "'></checkbox><label for='vb_" + vb + "'>" + key1.Replace('_', ' ') + "</label></span></div></th>");
               vb++;
           }
            %>
        </tr>

        <%
            
            
           double maxVal = 0;
           foreach (string key2 in var2.dict2.Keys)
           {
               foreach (string key1 in var1.dict2.Keys)
               {
                   double val = 0;
                   if (var1.dicb[key1].dict.ContainsKey(key2))
                   {
                       val = var1.dicb[key1].dict[key2].count * 100;
                       maxVal = Math.Max(maxVal, val);
                   }
               }
           }

           if (gridSelection.Count == 0)
           {
               // find largest value and select it
               double maxValue = -1;
               String maxCol1 = "";
               String maxCol2 = "";
               
               foreach (string key2 in var2.dict2.Keys)
               {
                   foreach (string key1 in var1.dict2.Keys)
                   {
                       double val = 0;
                       if (var1.dicb[key1].dict.ContainsKey(key2))
                           val = var1.dicb[key1].dict[key2].count * 100;
                       if (maxValue < val)
                       {
                           maxValue = val;
                           maxCol1 = var2.dict2[key2];
                           maxCol2 = var1.dict2[key1];
                       }
                   }
               }

               if (maxCol1 != "")
               {
                   AddSelection(maxCol1, maxCol2, maxValue);
                   LoadGrid();
                   selectedValue = Math.Round(maxValue);
                   
                   profiler.ColorRamp ramp = new profiler.ColorRamp();
                   ramp.Load(Server.MapPath("images/ramp.png"));
                   selectedColor = ramp.GetColor(maxValue / 100);
                   
                   
                   
               }
           }

           int hb = 0;
           foreach (string key2 in var2.dict2.Keys)
           {

               Response.Write("<tr>");
               Response.Write("<td>");
               Response.Write("<input type='checkbox' class='hcb' id='hb_" + hb + "'></checkbox><label for='hb_" + hb + "'>" + key2.Replace('_', ' ') + "</label>");
               Response.Write("</td>");


               foreach (string key1 in var1.dict2.Keys)
               {
                   double val = 0;
                   if (var1.dicb[key1].dict.ContainsKey(key2))
                       val = var1.dicb[key1].dict[key2].count * 100;
                   String col = ramp.GetColor(val / maxVal);

                   String c1 = var2.dict2[key2];
                   String c2 = var1.dict2[key1];
                   bool selected = IsSelected(c1, c2);
                   
                   
                   String sellClass = selected ? " bcell_bold" : "";

                   String title = c1 + "," + c2 + "," + val;
                   
                   Response.Write("<td class='bcell" + sellClass + "' style='background-color: " + col + "' name='" + title + "'>" + Math.Round(val) + "%</td>");
               }

               hb++;
               Response.Write("</tr>");

           }
        
       
        %>
    </table>
    <!--
    <br />
    <br />
    <input id="btnPlot" type="button" value="Plot selection" style="padding: 6px 20px;" />
    -->
    <br />
    <br />
    <% } %>
    <!--
    <a href="#" id="imgbtn">Show Images</a>
    -->
    <div id="divimg">
        Image Mask<br />
        <img src="<%=file_mask%>" alt="mask" style="border: 1px solid #e0e0e0" />
        <br />
        <br />
        <%=var1.name%><br />
        <img src="<%=file_v1%>" alt="mask" style="border: 1px solid #e0e0e0" />
        <% if (var2 != null)
           { %>
        <br />
        <br />
        <%=var2.name%><br />
        <img src="<%=file_v2%>" alt="mask" style="border: 1px solid #e0e0e0" />
        <% } %>
    </div>

    <% if (selectedValue > 0) { %>
    <script type="text/javascript">
        $(document).ready(function () {
            var val = '<%=selectedValue%>';
            var col = '<%=selectedColor%>';
            var frame = parent.global.relframe;
            var cell = parent.global.cellid;
            parent.parent.frames[frame].setCellVal(cell, val, col);
        });

        

    </script>

    <% } %>

</body>
</html>
