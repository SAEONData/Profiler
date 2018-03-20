using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.SqlClient;

namespace profiler
{
    public class GridTools
    {
        public GridTools(SqlConnection con, HttpContext c)
        {
            connection = con;
            context = c;
        }

        public int GetIndicatorID(String name)
        {
            String query = "SELECT fIndicatorID FROM TblIndicator WHERE fIndicatorName = @fIndicatorName";
            int indicatorID = -1;
            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@fIndicatorName", name);
                using (SqlDataReader set = cmd.ExecuteReader())
                {
                    if (set.Read() == true)
                    {
                        indicatorID = (int)set["fIndicatorID"];
                    }
                }
            }
            if (indicatorID == -1)
                return AddIndicator(name);
            else
                return indicatorID;
        }

        int AddIndicator(String name)
        {
            String sql = "INSERT INTO TblIndicator (fIndicatorName) VALUES (@fIndicatorName)";
            using (SqlCommand cmd = new SqlCommand(sql, connection))
            {

                cmd.Parameters.AddWithValue("@fIndicatorName", name);
                cmd.ExecuteNonQuery();
            }
            return GetIndicatorID(name);
        }

        public int GetGridID(int featureID, int indicator1, int indicator2)
        {
            String query = "SELECT fGridID FROM TblGrid WHERE fFeatureRef = @fFeatureRef AND fIndicator1Ref = @fIndicator1Ref AND fIndicator2Ref = @fIndicator2Ref";
            int gridID = -1;
            using (SqlCommand cmd = new SqlCommand(query, connection))
            {
                cmd.Parameters.AddWithValue("@fFeatureRef", featureID);
                cmd.Parameters.AddWithValue("@fIndicator1Ref", indicator1);
                cmd.Parameters.AddWithValue("@fIndicator2Ref", indicator2);
                using (SqlDataReader set = cmd.ExecuteReader())
                {
                    if (set.Read() == true)
                    {
                        gridID = (int)set["fGridID"];
                    }
                }
            }
            if (gridID == -1)
                return AddGrid(featureID, indicator1, indicator2);
            else
                return gridID;
        }

        int AddGrid(int featureID, int indicator1, int indicator2)
        {
            String sql = "INSERT INTO TblGrid (fFeatureRef, fIndicator1Ref, fIndicator2Ref) VALUES (@fFeatureRef, @fIndicator1Ref, @fIndicator2Ref)";
            using (SqlCommand cmd = new SqlCommand(sql, connection))
            {
                cmd.Parameters.AddWithValue("@fFeatureRef", featureID);
                cmd.Parameters.AddWithValue("@fIndicator1Ref", indicator1);
                cmd.Parameters.AddWithValue("@fIndicator2Ref", indicator2);
                cmd.ExecuteNonQuery();
            }
            return GetGridID(featureID, indicator1, indicator2);
        }



        private SqlConnection connection;
        private HttpContext context;
    }
}