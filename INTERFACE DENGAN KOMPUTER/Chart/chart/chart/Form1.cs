using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace chart
{
    public partial class Form1 : Form
    {
        int[] x = new int[] {1,2,3,4,5};
        int[] x2 = new int[] { 1, 2, 3, 4, 5 };
        int[] x3 = new int[] { 1, 2, 3, 4, 5 };
        double[] y = new double[] { 1.1 , 2.2, 3.3, 4.2, 5 };
        double[] y2 = new double[] { 1, 2, 3, 4, 5 };
        double[] y3 = new double[] { 1, 2.6, 3.9, 4.7, 5 };
        int count = 0;
        public Form1()
        {
            InitializeComponent();
        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            count++;
            if(count == 1)
            {
                chart1.Series["Series1"].Points.AddXY(x[0], y[0]);
                chart1.Series["Series2"].Points.AddXY(x2[0], y2[0]);
                chart1.Series["Series3"].Points.AddXY(x3[0], y3[0]);
            }
            else if(count ==2)
            {
                chart1.Series["Series1"].Points.AddXY(x[1], y[1]);
                chart1.Series["Series2"].Points.AddXY(x2[1], y2[1]);
                chart1.Series["Series3"].Points.AddXY(x3[1], y3[1]);
            }
            else if (count == 3)
            {
                chart1.Series["Series1"].Points.AddXY(x[2], y[2]);
                chart1.Series["Series2"].Points.AddXY(x2[2], y2[2]);
                chart1.Series["Series3"].Points.AddXY(x3[2], y3[2]);
            }
            else if (count == 4)
            {
                chart1.Series["Series1"].Points.AddXY(x[3], y[3]);
                chart1.Series["Series2"].Points.AddXY(x2[3], y2[3]);
                chart1.Series["Series3"].Points.AddXY(x3[3], y3[3]);
            }
            else if (count == 5)
            {
                chart1.Series["Series1"].Points.AddXY(x[4], y[4]);
                chart1.Series["Series2"].Points.AddXY(x2[4], y2[4]);
                chart1.Series["Series3"].Points.AddXY(x3[4], y3[4]);
                timer1.Enabled = false;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            chart1.Series["Series1"].Points.AddXY(0, 0);
            chart1.Series["Series2"].Points.AddXY(0, 0);
            chart1.Series["Series3"].Points.AddXY(0, 0);
            chart1.ChartAreas[0].AxisX.Title = "Time (s)";
            chart1.ChartAreas[0].AxisY.Title = "Voltage (V)";

            chart1.ChartAreas[0].AxisX.Maximum = 6;
            chart1.ChartAreas[0].AxisX.Minimum = 0;
            chart1.ChartAreas[0].AxisY.Maximum = 5;
            chart1.ChartAreas[0].AxisY.Minimum = 0;
            chart1.ChartAreas[0].AxisX.Interval = 1;
            chart1.ChartAreas[0].AxisY.Interval = 1;
        }
    }
}
