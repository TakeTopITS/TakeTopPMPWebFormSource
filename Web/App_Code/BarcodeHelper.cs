using System;
using System.Collections.Generic;
using System.Drawing;
using System.Drawing.Imaging;

using ZXing;
using ZXing.Common;
using ZXing.QrCode;
using ZXing.QrCode.Internal;

/// <summary>
/// 描述:条形码和二维码帮助类
/// 时间:2018-02-18
/// </summary>
public class BarcodeHelper
{

    // 起始字符和终止字符
    private const int StartCode = 104; // Code B起始字符
    private const int StopCode = 106;

    /// <summary>
    /// 生成条形码图像（支持字母和数字）
    /// </summary>
    /// <param name="content">要编码的内容（可包含字母和数字）</param>
    /// <param name="width">图像宽度</param>
    /// <param name="height">图像高度</param>
    /// <param name="barcodeFormat">条形码格式，默认为CODE_128</param>
    /// <returns>生成的条形码图像</returns>
    public static Bitmap GenerateBarCode( string content,  int width = 300,int height = 100)
    {
        BarcodeFormat barcodeFormat = BarcodeFormat.CODE_128;

        if (string.IsNullOrWhiteSpace(content))
            throw new ArgumentException("内容不能为空");

        var writer = new BarcodeWriter
        {
            Format = barcodeFormat,
            Options = new EncodingOptions
            {
                Width = width,
                Height = height,
                Margin = 1, // 设置边距
                PureBarcode = false // 是否在图像中包含文本
            }
        };

        try
        {
            return writer.Write(content);
        }
        catch (Exception ex)
        {
            throw new Exception("生成条形码时出错: " + ex.Message, ex);
        }
    }

    /// <summary>
    /// 保存条形码到文件
    /// </summary>
    public static void SaveBarcodeToFile(
        string content,
        string filePath,
        ImageFormat imageFormat = null,
        int width = 300,
        int height = 100)
    {
        imageFormat = imageFormat ?? ImageFormat.Png;

        using (var barcode = GenerateBarCode(content, width, height))
        {
            barcode.Save(filePath, imageFormat);
        }
    }

    /// <summary>
    /// 生成不带LOGO二维码
    /// </summary>
    /// <param name="text">内容</param>
    /// <param name="width">宽度</param>
    /// <param name="height">高度</param>
    /// <returns></returns>
    public static Bitmap GenerateNoLogoQrCode(string text, int width, int height)
    {
        BarcodeWriter writer = new BarcodeWriter();
        writer.Format = BarcodeFormat.QR_CODE;
        QrCodeEncodingOptions options = new QrCodeEncodingOptions()
        {
            DisableECI = true,//设置内容编码
            CharacterSet = "UTF-8",  //设置二维码的宽度和高度
            Width = width,
            Height = height,
            Margin = 1//设置二维码的边距,单位不是固定像素
        };

        writer.Options = options;
        Bitmap map = writer.Write(text);
        return map;
    }

    /// <summary>
    /// 生成带Logo的二维码
    /// </summary>
    /// <param name="text">内容</param>
    /// <param name="width">宽度</param>
    /// <param name="height">高度</param>
    public static Bitmap GenerateHaveLogoQrCode(string text, int width, int height)
    {
        //Logo 图片
        string logoPath = System.AppDomain.CurrentDomain.BaseDirectory + @"\Logo\FormLogo.png";
        Bitmap logo = new Bitmap(logoPath);
        //构造二维码写码器
        MultiFormatWriter writer = new MultiFormatWriter();
        Dictionary<EncodeHintType, object> hint = new Dictionary<EncodeHintType, object>();
        hint.Add(EncodeHintType.CHARACTER_SET, "UTF-8");
        hint.Add(EncodeHintType.ERROR_CORRECTION, ErrorCorrectionLevel.H);
        //hint.Add(EncodeHintType.MARGIN, 2);//旧版本不起作用，需要手动去除白边

        //生成二维码
        BitMatrix bm = writer.encode(text, BarcodeFormat.QR_CODE, width + 30, height + 30, hint);
        bm = deleteWhite(bm);
        BarcodeWriter barcodeWriter = new BarcodeWriter();
        Bitmap map = barcodeWriter.Write(bm);

        //获取二维码实际尺寸（去掉二维码两边空白后的实际尺寸）
        int[] rectangle = bm.getEnclosingRectangle();

        //计算插入图片的大小和位置
        int middleW = Math.Min((int)(rectangle[2] / 3), logo.Width);
        int middleH = Math.Min((int)(rectangle[3] / 3), logo.Height);
        int middleL = (map.Width - middleW) / 2;
        int middleT = (map.Height - middleH) / 2;

        Bitmap bmpimg = new Bitmap(map.Width, map.Height, PixelFormat.Format32bppArgb);
        using (Graphics g = Graphics.FromImage(bmpimg))
        {
            g.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.HighQualityBicubic;
            g.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality;
            g.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality;
            g.DrawImage(map, 0, 0, width, height);
            //白底将二维码插入图片
            g.FillRectangle(Brushes.White, middleL, middleT, middleW, middleH);
            g.DrawImage(logo, middleL, middleT, middleW, middleH);
        }

        return bmpimg;
    }

    /// <summary>
    /// 删除默认对应的空白
    /// </summary>
    /// <param name="matrix"></param>
    /// <returns></returns>
    private static BitMatrix deleteWhite(BitMatrix matrix)
    {
        int[] rec = matrix.getEnclosingRectangle();
        int resWidth = rec[2] + 1;
        int resHeight = rec[3] + 1;

        BitMatrix resMatrix = new BitMatrix(resWidth, resHeight);
        resMatrix.clear();
        for (int i = 0; i < resWidth; i++)
        {
            for (int j = 0; j < resHeight; j++)
            {
                if (matrix[i + rec[0], j + rec[1]])
                    resMatrix[i, j] = true;
            }
        }
        return resMatrix;
    }
}