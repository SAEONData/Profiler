<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="note.aspx.cs" Inherits="profiler.note" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Note Builder</title>
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
        .vspacer {
            height: 8px;
        }
    </style>
    <script type="text/javascript">
        var global = {
            recordIndex: 100,
            recordID: 0,
            records: [],
            filterIndex: 100,
            filterID: 0,
            filters: []
        };

        function editCol(id) {
            global.recordID = id;
            var rec = id ? global.records[id] : null;
            $('#dlgLegend').val(rec ? rec.legend : '');
            $('#dlgColor').val(rec ? rec.colour : '');
            $('#dlgValue').val(rec ? rec.value : '');
            $('#coldlg').modal();
        }

        function saveColRow() {
            var legend = $('#dlgLegend').val();
            var colour = $('#dlgColor').val();
            var value = $('#dlgValue').val();

            var id = global.recordID;
            if (id == null)
                id = global.recordIndex++;

            global.records[id] = {
                legend: legend,
                colour: colour,
                value: value
            }

            var crow = '';
            crow += '<td>' + legend + '</td>';
            crow += '<td>';
            crow += '<span style="width: 10px; border: 1px solid black;background-color: ' + colour + '">&nbsp;&nbsp;&nbsp;&nbsp;</span>&nbsp;';
            crow += colour;
            crow += '</td>';
            crow += '<td>' + value + '</td>';
            crow += '<td>';
            crow += '<button type="button" class="btn btn-default btn-sm" title="Edit" onclick="editCol(' + id + ');"  >';
            crow += '<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>';
            crow += '</button>&nbsp;';
            crow += '<button type="button" class="btn btn-default btn-sm" title="Delete" onclick="delCol(' + id + ');" >';
            crow += '<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>';
            crow += '</button>';
            crow += '</td>';

            if (global.recordID == null) {
                var code = '<tr id="tr' + id + '">';
                code += crow;
                code += '</tr>';
                $('#colbody').append($(code));
            }
            else {
                $('#tr' + global.recordID).html($(crow));
            }

            $('#coldlg').modal('toggle');
        }

        function delCol(id) {
            $('#tr' + id).remove();
        }

        function editFilter(id) {
            global.filterID = id;
            var rec = id ? global.filters[id] : null;
            $('#dlgName').val(rec ? rec.name : '');
            $('#dlgThemes').val(rec ? rec.themes : '');
            $('#filterDlg').modal();
        }

        function saveFilter() {
            var name = $('#dlgName').val();
            var themes = $('#dlgThemes').val();

            var id = global.filterID;
            if (id == null)
                id = global.filterIndex++;

            global.filters[id] = {
                name: name,
                themes: themes,
            }

            debugger;

            var crow = '';
            crow += '<td>' + name + '</td>';
            crow += '<td>' + themes + '</td>';
            crow += '<td>';
            crow += '<button type="button" class="btn btn-default btn-sm" title="Edit" onclick="editFilter(' + id + ');"  >';
            crow += '<span class="glyphicon glyphicon-edit" aria-hidden="true"></span>';
            crow += '</button>&nbsp;';
            crow += '<button type="button" class="btn btn-default btn-sm" title="Delete" onclick="deleteFilter(' + id + ');" >';
            crow += '<span class="glyphicon glyphicon-remove" aria-hidden="true"></span>';
            crow += '</button>';
            crow += '</td>';

            if (global.filterID == null) {
                var code = '<tr id="fr' + id + '">';
                code += crow;
                code += '</tr>';
                $('#filterBody').append($(code));
            }
            else {
                $('#fr' + global.filterID).html($(crow));
            }

            $('#filterDlg').modal('toggle');
        }

        function deleteFilter(id) {
            $('#fr' + id).remove();
        }

        function viewJson() {
            var json = $('#noteText').val() + '\\nLink- ' + $('#noteLink').val() + '\\n'
            json += '{\\"title\\": \\"' + $('#noteTitle').val() + '\\",\\n';
            json += '\\"application\\": \\"' + $('#noteApp').val() + '\\",\\n';
            json += '\\"style\\":\\"' + $('#noteStyle').val() + '\\",\\n';
            json += '\\"aggregation\\":\\"' + $('#noteAggr').val() + '\\",\\n';

            var colors = '';
            $('#coltable > tbody  > tr').each(function(a, row) {
                var id = row.id.substr(2);
                var rec = global.records[id];
                if (colors != '')
                    colors += ',';
                colors += '\\n{\\"' + rec.legend + '\\":\\"#' + rec.colour + ',' + rec.value + '\\"}';
            });
            json += '\\"colourmap\\": [' + colors + '\\n],';

            var filters = '';
            $('#filterTable > tbody  > tr').each(function (a, row) {
                var id = row.id.substr(2);
                var rec = global.filters[id];
                if (filters != '')
                    filters += ',';
                var themes = '' + rec.themes;
                for (var i = 0; i < 100; i++)
                    themes = themes.replace('\n', ',');
                filters += '\\n{\\"filtername\\":\\"' + rec.name + '\\",\\"themes\\":\\"' + themes + '\\"}';
            });
            json += '\\"filters\\": [' + filters + '\\n]\\n}';


            $('#txtJSon').val(json);
            $('#jsonDlg').modal();
           
        }

        console.log('\nLink- \n{\"title\": \"\",\n\"application\": \"\",\n\"style\":\"\",\n\"aggregation\":\"sum\",\n\"colourmap\": [\n{\"l1\":\"#c1,v1\"},\n{\"l2\":\"#c2,v2\"}\n],\"filters\": [\n{\"filtername\":\"n1\",\"themes\":\"t1,t2\"},\n{\"filtername\":\"n2\",\"themes\":\"u2,u2\"}\n]\n}');

        var qq = {
            "title": "",
            "application": "",
            "style": "",
            "aggregation": "sum",
            "colourmap": [
            { "c1": "##ff00ff,1" },
            { "c2": "##cc00cc,2" }
            ], "filters":
            [
            { "filtername": "f1", "themes": "t1,t2" },
            { "filtername": "f2", "themes": "y1,y2" }
            ]
        }

        
    </script>
</head>
<body style ="margin-left: 100px; padding-right: 100px; margin-top: 20px">
    <form id="form1" runat="server">
    <div>
        <h5><b>Basic information</b></h5>
        <table style="width: 100%">
            <tr>
                <td style="width: 100px;">Text:</td>
                <td>
                    <input type="text" class="form-control" id="noteText" />
                </td>
            </tr>
            <tr><td class="vspacer"></td></tr>
            <tr>
                <td>Link:</td>
                <td>
                    <input type="text" class="form-control" id="noteLink" />
                </td>
            </tr>
        </table>
        <hr />
        <h5><b>Indicator</b></h5>
        <table style="width: 100%">
            <tr>
                <td style="width: 100px;">Title:</td>
                <td>
                    <input type="text" class="form-control" id="noteTitle" />
                </td>
            </tr>
            <tr><td class="vspacer"></td></tr>
            <tr>
                <td>Application:</td>
                <td>
                    <input type="text" class="form-control" id="noteApp" />
                </td>
            </tr>
            <tr><td class="vspacer"></td></tr>
            <tr>
                <td>Style:</td>
                <td>
                    <input type="text" class="form-control" id="noteStyle" />
                </td>
            </tr>
            <tr><td class="vspacer"></td></tr>
            <tr>
                <td>Aggregation:</td>
                <td>
                    <select class="form-control" id="noteAggr">
                        <option>sum</option>
                        <option>count</option>
                    </select>
                </td>
            </tr>
        </table>
        <hr />
        <table>
            <tr>
                <td style="width: 80px">
                    <h5><b>Colour Map</b></h5>
                </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>
                    <button type="button" class="btn btn-default btn-sm" title="Add Row" onclick="editCol(null);">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                    </button>
                    &nbsp;
                    <button type="button" class="btn btn-default btn-sm" title="Add Row" onclick="alert('todo')">
                        <span class="glyphicon glyphicon-upload" aria-hidden="true"></span>&nbsp;Import SLD
                    </button>
                </td>
            </tr>
        </table>

        <table class="table" id="coltable">
            <thead>
                <tr>
                    <td>Legend</td>
                    <td>Colour</td>
                    <td>Value</td>
                    <td>...</td>
                </tr>
            </thead>

            <tbody id="colbody">
            </tbody>

        </table>

        <table>
            <tr>
                <td style="width: 80px">
                    <h5><b>Filters</b></h5>
                </td>
                <td>
                    &nbsp;&nbsp;
                </td>
                <td>
                    <button type="button" class="btn btn-default btn-sm" title="Add Row" onclick="editFilter(null);">
                        <span class="glyphicon glyphicon-plus" aria-hidden="true"></span>
                    </button>
                </td>
            </tr>
        </table>

        <table class="table" id="filterTable">
            <thead>
                <tr>
                    <td>Filter Name</td>
                    <td>Themes</td>
                    <td>...</td>
                </tr>
            </thead>

            <tbody id="filterBody">
            </tbody>

        </table>



        <div class="modal fade" id="coldlg">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Map Entry</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <table style="width: 100%">
                    <tr>
                        <td style="width: 100px;">Legend:</td>
                        <td>
                            <input type="text" class="form-control" id="dlgLegend"  placeholder="0 - 10" />
                        </td>
                    </tr>
                    <tr><td class="vspacer"></td></tr>
                    <tr>
                        <td>Colour:</td>
                        <td>
                            <input type="text" class="form-control" id="dlgColor" placeholder="#ff00ff" />
                        </td>
                    </tr>
                    <tr><td class="vspacer"></td></tr>
                    <tr>
                        <td>Value:</td>
                        <td>
                            <input type="text" class="form-control" id="dlgValue" placeholder="5" />
                        </td>
                    </tr>
                </table>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="saveColRow();">Ok</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
              </div>
            </div>
          </div>
        </div>

        <div class="modal fade" id="filterDlg">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Filter</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <table style="width: 100%">
                    <tr>
                        <td style="width: 100px;">Name:</td>
                        <td>
                            <input type="text" class="form-control" id="dlgName"  />
                        </td>
                    </tr>
                    <tr><td class="vspacer"></td></tr>
                    <tr>
                        <td>Themes:</td>
                        <td>
                            <textarea class="form-control" id="dlgThemes" style="height: 100px;"></textarea>
                        </td>
                    </tr>
                </table>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" onclick="saveFilter();">Ok</button>
                <button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
              </div>
            </div>
          </div>
        </div>

        <div class="modal fade" id="jsonDlg">
          <div class="modal-dialog" role="document">
            <div class="modal-content">
              <div class="modal-header">
                <h5 class="modal-title">Note Text</h5>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
              </div>
              <div class="modal-body">
                <textarea class="form-control" id="txtJSon" style="height: 300px;"></textarea>
              </div>
              <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
              </div>
            </div>
          </div>
        </div>

        <button type="button" class="btn btn-default btn-sm" title="Add Row" onclick="viewJson();">
            <span class="glyphicon glyphicon-fire" aria-hidden="true"></span> View Note
        </button>


        <!--
        "text": "Population Living in Poverty\nLink- http://www.sasdi.net/metaview.aspx?uuid=6fab3f1cb219722e76bf3c2ac9c90443 Server- 8086\n
            {\"title\": \"Population Living in Poverty\",\n
             \"application\": \"This is the application\",\n
             \"style\":\"Meso_pop_income_education\",\n
             \"aggregation\":\"sum\",\n
             \"colourmap\": \n[\n{\"0 - 2\":\"#f7fbff,1\"},\n{\"2 - 12\":\"#c7dcef,7\"},\n{\"12 - 48\":\"72b2d7,30\"},\n{\"48 - 268\":\"#2878b8,160\"},\n{\"268 - 341935\":\"#08306b,150000\"}\n]\n}"
        -->
    
    </div>
    </form>
</body>
</html>
