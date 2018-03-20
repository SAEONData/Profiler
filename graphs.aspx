<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="graphs.aspx.cs" Inherits="profiler.graphs" %>

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

    <script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>

    <script type="text/javascript">

        function resizeGraphBox() {

            var offset = 32;

            var cy = $(window).height();
            var cx = $(window).width();
            $('#chartbox').height(cy - (142 - offset));
            $('#chartbox').width(cx - 70);
            $('#vertToolBox').css('top', cy - (90 - offset));
            $('#dateSlider').width(cx - 440);


        }


        function initChart() {

            google.charts.load('current', { 'packages': ['corechart'] });
            google.charts.setOnLoadCallback(drawSeriesChart);

            function drawSeriesChart() {

                var data = google.visualization.arrayToDataTable([
                ['ID', 'Life Expectancy', 'Fertility Rate', 'Region', 'Population'],
                ['CAN', 80.66, 1.67, 'North America', 33739900],
                ['DEU', 79.84, 1.36, 'Europe', 81902307],
                ['DNK', 78.6, 1.84, 'Europe', 5523095],
                ['EGY', 72.73, 2.78, 'Middle East', 79716203],
                ['GBR', 80.05, 2, 'Europe', 61801570],
                ['IRN', 72.49, 1.7, 'Middle East', 73137148],
                ['IRQ', 68.09, 4.77, 'Middle East', 31090763],
                ['ISR', 81.55, 2.96, 'Middle East', 7485600],
                ['RUS', 68.6, 1.54, 'Europe', 141850000],
                ['USA', 78.09, 2.05, 'North America', 307007000]
                ]);

                var options = {
                    bubble: { textStyle: { fontSize: 11 } }
                };

                var chart = new google.visualization.BubbleChart(document.getElementById('chartbox'));
                chart.draw(data, options);
            }

        }


        $(document).ready(function () {
            $(window).on('resize', resizeGraphBox);
            resizeGraphBox();

            $('#dateSlider').slider({
                formatter: function (value) {
                    return value;
                }
            });

            initChart();
        });

    </script>
</head>
<body style="padding-left: 10px; overflow-x: hidden; overflow-y: hidden">
    <form id="form1" runat="server">




        <!-- side toolbox -->
        <div id="vertToolBox" class="vertical-text" style="position: absolute; left: 10px; top: 320px;">
            <table>
                <tr>
                    <td>Variable:</td>
                    <td style="width: 8px"></td>
                    <td>
                        <select id="vertVar" class="form-control" style="width: 200px;">
                            <option>Option 1</option>
                            <option>Option 2</option>
                            <option>Option 3</option>
                            <option>Option 4</option>
                        </select>
                    </td>
                    <td style="width: 8px"></td>
                    <td>
                        <button type="button" class="btn btn-default" aria-label="Left Align">
                            <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                        </button>
                    </td>
                </tr>
            </table>
        </div>


        <div style="left: 56px; top: 10px; position: absolute">
            <!-- top toolbox -->
            <div class="" style="">
                <table>
                    <tr>
                        <td>Area of interrest:</td>
                        <td style="width: 8px"></td>
                        <td>
                            <select id="Select2" class="form-control" style="width: 200px;">
                                <option>Option 1</option>
                                <option>Option 2</option>
                                <option>Option 3</option>
                                <option>Option 4</option>
                            </select>
                        </td>
                        <td style="width: 8px"></td>
                        <td style="width: 8px"></td>
                        <td>Aggregation:</td>
                        <td style="width: 8px"></td>
                        <td>
                            <select id="Select3" class="form-control" style="width: 200px;">
                                <option>Option 1</option>
                                <option>Option 2</option>
                                <option>Option 3</option>
                                <option>Option 4</option>
                            </select>
                        </td>
                        <td style="width: 8px"></td>
                        <td>
                            <button type="button" class="btn btn-default" aria-label="Left Align">
                                <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                            </button>
                        </td>
                    </tr>
                </table>
            </div>

            <!-- spacer -->
            <div style="height: 10px;"></div>

            <iframe id="chartbox" src="map.aspx">
            </iframe>

            <!-- spacer -->
            <div style="height: 10px;"></div>

            <!-- bottom toolbox -->
            <div class="" style="">
                <table>
                    <tr>
                        <td>Variable:</td>
                        <td style="width: 8px"></td>
                        <td>
                            <select id="Select1" class="form-control" style="width: 200px;">
                                <option>Option 1</option>
                                <option>Option 2</option>
                                <option>Option 3</option>
                                <option>Option 4</option>
                            </select>
                        </td>
                        <td style="width: 8px"></td>
                        <td>
                            <button type="button" class="btn btn-default" aria-label="Left Align">
                                <span class="glyphicon glyphicon-cog" aria-hidden="true"></span>
                            </button>
                        </td>
                        <td style="width: 8px"></td>
                        <td style="width: 8px"></td>
                        <td>Date:
                        </td>
                        <td style="width: 8px"></td>
                        <td>
                            <input style="" id="dateSlider" data-slider-id='ex1Slider' type="text" data-slider-min="1991" data-slider-max="2017" data-slider-step="1" data-slider-value="2013" />
                        </td>
                    </tr>
                </table>
            </div>


        </div>



    </form>
</body>
</html>
