using System;
using System.Resources;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Drawing;

public partial class TTCheckCode : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        // 清除输出缓存，确保每次都是新图片
        Response.Cache.SetCacheability(HttpCacheability.NoCache);
        Response.Cache.SetExpires(DateTime.Now.AddSeconds(-1));
        Response.Cache.SetNoStore();

        // 生成并显示验证码
        this.CreateCheckCodeImageWithStringFormat(GenerateCheckCode());
    }

    private string GenerateCheckCode()
    {
        int number;
        char code;
        string checkCode = String.Empty;

        System.Random random = new Random();

        for (int i = 0; i < 5; i++)
        {
            number = random.Next();

            if (number % 2 == 0)
                code = (char)('0' + (char)(number % 10));
            else
                code = (char)('A' + (char)(number % 26));

            checkCode += code.ToString();
        }

        // 重要：每次生成验证码都更新Session
        Session["CheckCode"] = checkCode;

        return checkCode;
    }

    private void CreateCheckCodeImageWithStringFormat(string checkCode)
    {
        if (checkCode == null || checkCode.Trim() == String.Empty)
            return;

        System.Drawing.Bitmap image = new System.Drawing.Bitmap((int)Math.Ceiling((double)(checkCode.Length * 15)), 30);
        image.SetResolution(96, 96);

        Graphics g = Graphics.FromImage(image);

        try
        {
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
            g.TextRenderingHint = System.Drawing.Text.TextRenderingHint.AntiAlias;

            Random random = new Random();
            g.Clear(Color.White);

            //画图片的背景噪音线
            for (int i = 0; i < 25; i++)
            {
                int x1 = random.Next(image.Width);
                int x2 = random.Next(image.Width);
                int y1 = random.Next(image.Height);
                int y2 = random.Next(image.Height);
                g.DrawLine(new Pen(Color.Silver), x1, y1, x2, y2);
            }

            // 使用您设置的14f字体大小
            Font font = new Font("Arial", 14f, FontStyle.Bold | FontStyle.Italic, GraphicsUnit.Point);
            System.Drawing.Drawing2D.LinearGradientBrush brush = new System.Drawing.Drawing2D.LinearGradientBrush(
                new Rectangle(0, 0, image.Width, image.Height),
                Color.Blue,
                Color.DarkRed,
                1.2f,
                true);

            // 使用StringFormat实现精确居中
            StringFormat format = new StringFormat();
            format.Alignment = StringAlignment.Center;     // 水平居中
            format.LineAlignment = StringAlignment.Center; // 垂直居中

            // 创建绘制区域
            RectangleF rectF = new RectangleF(0, 0, image.Width, image.Height);

            // 绘制文本 - 会自动居中
            g.DrawString(checkCode, font, brush, rectF, format);

            //画图片的前景噪音点
            for (int i = 0; i < 100; i++)
            {
                int x = random.Next(image.Width);
                int y = random.Next(image.Height);
                image.SetPixel(x, y, Color.FromArgb(random.Next()));
            }

            //画图片的边框线
            g.DrawRectangle(new Pen(Color.Silver), 0, 0, image.Width - 1, image.Height - 1);

            System.IO.MemoryStream ms = new System.IO.MemoryStream();
            image.Save(ms, System.Drawing.Imaging.ImageFormat.Gif);
            Response.ClearContent();
            Response.ContentType = "image/Gif";
            Response.BinaryWrite(ms.ToArray());
        }
        finally
        {
            g.Dispose();
            image.Dispose();
        }
    }
}