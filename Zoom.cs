using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace profiler
{
    class CScreenRect
    {
    public CScreenRect() {
		    x1 = 0;
		    y1 = 0;
		    x2 = 0;
		    y2 = 0;
	    }

    public CScreenRect(int dx1, int dy1, int dx2, int dy2) {
		    x1 = dx1;
		    y1 = dy1;
		    x2 = dx2;
		    y2 = dy2;
	    }

    public CScreenRect(CScreenRect rect) {
		    x1 = rect.x1;
		    y1 = rect.y1;
		    x2 = rect.x2;
		    y2 = rect.y2;
	    }

    
	    public int x1;
	    public int y1;
	    public int x2;
	    public int y2;
    };

    class CMapRect
    {
    
	public CMapRect() {
		    x1 = 0;
		    y1 = 0;
		    x2 = 0;
		    y2 = 0;
	    }

	public CMapRect(double dx1, double dy1, double dx2, double dy2) {
		    x1 = dx1;
		    y1 = dy1;
		    x2 = dx2;
		    y2 = dy2;
	    }

	    public CMapRect(CMapRect rect) {
		    x1 = rect.x1;
		    y1 = rect.y1;
		    x2 = rect.x2;
		    y2 = rect.y2;
	    }

    
	    public double x1;
	    public double y1;
	    public double x2;
	    public double y2;
    };

    class CZoom  
    {
        public void ZoomToFullExtent(CMapRect map_rect, CScreenRect screen_rect)
        {
            double dDwgWidth = map_rect.x2 - map_rect.x1;
            double dDwgHeight = map_rect.y2 - map_rect.y1;

            double dScrWidth = (screen_rect.x2 - screen_rect.x1);
            double dScrHeight = (screen_rect.y2 - screen_rect.y1);

            double dXFactor = dScrWidth / dDwgWidth;
            double dYFactor = dScrHeight / dDwgHeight;

            m_dZoomFactorX = dXFactor;
            m_dZoomFactorY = dYFactor;

            m_dXOffset = (map_rect.x1 + (dDwgWidth / 2)) * m_dZoomFactorX;
            m_dYOffset = (map_rect.y1 + (dDwgHeight / 2)) * m_dZoomFactorY;
            m_dXCenter = (dScrWidth / 2) - m_dXOffset;
            m_dYCenter = (dScrHeight / 2) - m_dYOffset;

            // save map rect
            m_zoomRect = new CMapRect();
            m_zoomRect.x1 = map_rect.x1;
            m_zoomRect.y1 = map_rect.y1;
            m_zoomRect.x2 = map_rect.x2;
            m_zoomRect.y2 = map_rect.y2;

            // save clip rect
            dXFactor = (map_rect.x2 - map_rect.x1) / 5.0;
            m_clipRect = new CMapRect();
            m_clipRect.x1 = map_rect.x1 - dXFactor;
            m_clipRect.y1 = map_rect.y1 - dXFactor;
            m_clipRect.x2 = map_rect.x2 + dXFactor;
            m_clipRect.y2 = map_rect.y2 + dXFactor;

            // save screen rect
            m_screenRect = new CScreenRect();
            m_screenRect.x1 = screen_rect.x1;
            m_screenRect.y1 = screen_rect.y1;
            m_screenRect.x2 = screen_rect.x2;
            m_screenRect.y2 = screen_rect.y2;
        }


        public void Map2Screen(double mx, double my, out int sx, out int sy)
        {
            sx = m_screenRect.x1 + (int)(mx * m_dZoomFactorX + m_dXCenter);
            sy = m_screenRect.y2 - (int)(my * m_dZoomFactorY + m_dYCenter);
        }

        public void Screen2Map(int sx, int sy, out double mx, out double my)
        {
            mx = ((double)sx - m_dXCenter) / m_dZoomFactorX;
            my = ((double)sy - m_dYCenter) / m_dZoomFactorY;
        }

    
	    public double m_dZoomFactorX;
	    public double m_dZoomFactorY;
	    public double m_dXOffset;
	    public double m_dYOffset;
	    public double m_dXCenter;
	    public double m_dYCenter;
	    public CMapRect m_zoomRect;
	    public CMapRect m_clipRect;
	    public CScreenRect m_screenRect;
    };


}