using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using Tarmac64;
using Tarmac64_Geometry;
using Tarmac64_Library;
using Cereal64;
using Texture64;
using System.Drawing.Imaging;
using Aspose;
using Aspose.ThreeD;
using System.Globalization;

namespace MK64Help
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        TM64 tarmac64 = new TM64();
        TM64_Geometry tarmacLibrary = new TM64_Geometry();
        FolderBrowserDialog folderOpen = new FolderBrowserDialog();
        OpenFileDialog fileOpen = new OpenFileDialog();
        SaveFileDialog fileSave = new SaveFileDialog();

        private void button1_Click(object sender, EventArgs e)
        {
            
            string searchString = searchBox.Text;
            

            if (folderOpen.ShowDialog() == DialogResult.OK)
            {
                string input = folderOpen.SelectedPath;
                if (folderOpen.ShowDialog() == DialogResult.OK)
                {
                    string output = folderOpen.SelectedPath;
                    string[] files = Directory.GetFiles(input, searchString, SearchOption.AllDirectories);

                    foreach (var copy in files)
                    {
                        File.Copy(copy, Path.Combine(output, Path.GetFileName(copy)));
                    }
                }
            }
            
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            
            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] fileData = File.ReadAllBytes(fileOpen.FileName);



                byte[] compressedData = tarmacLibrary.compressMIO0(fileData);
                
                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllBytes(fileSave.FileName, compressedData);
                }

            }
        }

        private void button5_Click(object sender, EventArgs e)
        {
            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] fileData = File.ReadAllBytes(fileOpen.FileName);



                byte[] uncompressedData = tarmacLibrary.decompressMIO0(fileData);

                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllBytes(fileSave.FileName, uncompressedData);
                }

            }
        }

        private void button3_Click(object sender, EventArgs e)
        {
            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] fileData = File.ReadAllBytes(fileOpen.FileName);



                byte[] compressedData = tarmacLibrary.compress_seg7(fileData);

                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllBytes(fileSave.FileName, compressedData);
                }

            }
        }

        private void button4_Click(object sender, EventArgs e)
        {
            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] fileData = File.ReadAllBytes(fileOpen.FileName);



                byte[] uncompressedData = tarmacLibrary.decompress_seg7(fileData);

                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllBytes(fileSave.FileName, uncompressedData);
                }

            }
        }

        private void button6_Click(object sender, EventArgs e)
        {
            FolderBrowserDialog folderOpen = new FolderBrowserDialog();
            if (folderOpen.ShowDialog() == DialogResult.OK)
            {

                foreach (string file in Directory.GetFiles(folderOpen.SelectedPath, "*.c"))
                {
                    string[] fileData = File.ReadAllLines(file);
                    List<byte> byteList = new List<byte>();

                    //past the intro start at 1
                    for (int currentLine = 1; currentLine < fileData.Length - 2; currentLine++)
                    {
                        string thisLine = fileData[currentLine];

                        string[] itemArray = thisLine.Split(',');

                        foreach (var currentItem in itemArray)
                        {
                            if (currentItem.Length > 0)
                            {
                                string editedItem = currentItem.Replace("0x", "");
                                editedItem = editedItem.Replace("\"", "");
                                byteList.Add(Convert.ToByte(editedItem, 16));
                            }
                        }
                    }



                    string outPath = Path.Combine(Path.GetDirectoryName(file), "Output");





                    int addressAlign = 4 - (byteList.Count % 4);
                    if (addressAlign == 4)
                        addressAlign = 0;
                    for (int align = 0; align < addressAlign; align++)
                    {
                        byteList.Add(0xFF);
                    }

                    byte[] byteArray = byteList.ToArray();
                    Directory.CreateDirectory(outPath);
                    outPath = Path.Combine(outPath, Path.GetFileName(file));
                    File.WriteAllBytes(outPath + ".data.bin", byteArray);
                    TM64_Geometry mk = new TM64_Geometry();

                    try
                    {
                        byte[] textureData = mk.decompressMIO0(byteArray);


                        int width, height = 0;
                        byte[] voidBytes = new byte[0];

                        if (textureData.Length == 0x800)
                        {
                            width = 32;
                            height = 32;

                            Bitmap exportBitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);
                            Graphics graphicsBitmap = Graphics.FromImage(exportBitmap);
                            N64Graphics.RenderTexture(graphicsBitmap, textureData, voidBytes, 0, width, height, 1, N64Codec.RGBA16, N64IMode.AlphaCopyIntensity);

                            string texturePath = (outPath + ".png");

                            exportBitmap.Save(texturePath, ImageFormat.Png);


                        }
                        else
                        {
                            width = 32;
                            height = 64;

                            Bitmap exportBitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);
                            Graphics graphicsBitmap = Graphics.FromImage(exportBitmap);
                            N64Graphics.RenderTexture(graphicsBitmap, textureData, voidBytes, 0, width, height, 1, N64Codec.RGBA16, N64IMode.AlphaCopyIntensity);

                            string texturePath = (outPath + ".32x64.png");

                            exportBitmap.Save(texturePath, ImageFormat.Png);

                            width = 64;
                            height = 32;

                            exportBitmap = new Bitmap(width, height, PixelFormat.Format32bppArgb);
                            graphicsBitmap = Graphics.FromImage(exportBitmap);
                            N64Graphics.RenderTexture(graphicsBitmap, textureData, voidBytes, 0, width, height, 1, N64Codec.RGBA16, N64IMode.AlphaCopyIntensity);

                            texturePath = (outPath + ".64x32.png");

                            exportBitmap.Save(texturePath, ImageFormat.Png);
                        }
                    }
                    catch (Exception)
                    {

                        continue;
                    }



                }


            }
        }

        private void button7_Click(object sender, EventArgs e)
        {
            OpenFileDialog fileOpen = new OpenFileDialog();

            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] segment4 = File.ReadAllBytes(fileOpen.FileName);



                List<byte> insert = new List<byte> { 0x00, 0x00 };
                int vertcount = segment4.Length / 14;

                List<byte> vertList = segment4.ToList();
                for (int i = 0; i < vertcount; i++)
                {
                    vertList.InsertRange((i + 1) * 10 + (i * 2) + (i * 4), insert);
                }
                byte[] seg4 = vertList.ToArray();

                SaveFileDialog fileSave = new SaveFileDialog();
                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllBytes(fileSave.FileName, seg4);
                }
            }
        }

        private void button8_Click(object sender, EventArgs e)
        {
            MessageBox.Show("Segment 4 Uncompressed");
            OpenFileDialog fileOpen = new OpenFileDialog();

            if (fileOpen.ShowDialog() == DialogResult.OK)
            {
                byte[] segment4 = File.ReadAllBytes(fileOpen.FileName);

                MessageBox.Show("Segment 7 Uncompressed");

                if (fileOpen.ShowDialog() == DialogResult.OK)
                {
                    byte[] segment7 = File.ReadAllBytes(fileOpen.FileName);

                    MessageBox.Show("File Save");
                    SaveFileDialog fileSave = new SaveFileDialog();

                    if (fileSave.ShowDialog() == DialogResult.OK)
                    {
                        Aspose.ThreeD.Scene exportData = tarmac64.dumpface2(segment4, segment7);
                        exportData.Save(fileSave.FileName, FileFormat.WavefrontOBJ);
                    }
                }
            }
        }

        private void button9_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFile = new OpenFileDialog();
            if (openFile.ShowDialog() == DialogResult.OK)
            {
                byte[] vertData = File.ReadAllBytes(openFile.FileName);

                string[] outData = tarmacLibrary.DumpVerts(vertData);

                SaveFileDialog saveFile = new SaveFileDialog();
                if (saveFile.ShowDialog() == DialogResult.OK)
                {
                    File.WriteAllLines(saveFile.FileName, outData);
                }

            }
        }

        private void label2_Click(object sender, EventArgs e)
        {

        }

        private void button10_Click(object sender, EventArgs e)
        {
            if (fileOpen.ShowDialog() == DialogResult.OK)
            {

                string[] fileData = File.ReadAllLines(fileOpen.FileName);
                List<byte> segment4 = new List<byte>();
                List<byte> segment7 = new List<byte>();

                for (int currentLine = 4; currentLine < 2222; currentLine++)
                {
                    fileData[currentLine] = fileData[currentLine].Replace("0x", "");
                    string[] byteString = fileData[currentLine].Split(',');
                    
                    foreach(string thisLine in byteString)
                    {
                        if (thisLine != "")
                        {
                            segment4.Add(byte.Parse(thisLine, System.Globalization.NumberStyles.HexNumber));
                        }
                    }
                }

                for (int currentLine = 2238; currentLine < 3202; currentLine++)
                {
                    fileData[currentLine] = fileData[currentLine].Replace("0x", "");
                    string[] byteString = fileData[currentLine].Split(',');

                    foreach (string thisLine in byteString)
                    {
                        if (thisLine != "")
                        {
                            segment7.Add(byte.Parse(thisLine, System.Globalization.NumberStyles.HexNumber));
                        }
                    }
                }

                byte[] seg4 = tarmac64.decompressMIO0(segment4.ToArray());
                byte[] seg7 = tarmacLibrary.decompress_seg7(segment7.ToArray());

                MessageBox.Show("File Save");
                SaveFileDialog fileSave = new SaveFileDialog();

                if (fileSave.ShowDialog() == DialogResult.OK)
                {
                    Aspose.ThreeD.Scene exportData = tarmac64.dumpface2(seg4, seg7);
                    exportData.Save(fileSave.FileName, FileFormat.WavefrontOBJ);
                }
            }

        }
        
    }
    
    
}
