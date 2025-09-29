//Copy this CustomPainter code to the Bottom of the File
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class VideoBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.09677419);
    path_0.cubicTo(
      0,
      size.height * 0.04332726,
      size.width * 0.01637982,
      0,
      size.width * 0.03658537,
      0,
    );
    path_0.lineTo(size.width * 0.5389604, 0);
    path_0.cubicTo(
      size.width * 0.5559146,
      0,
      size.width * 0.5721037,
      size.height * 0.01867452,
      size.width * 0.5836402,
      size.height * 0.05154016,
    );
    path_0.lineTo(size.width * 0.6303415, size.height * 0.1845742);
    path_0.cubicTo(
      size.width * 0.6395732,
      size.height * 0.2108669,
      size.width * 0.6525244,
      size.height * 0.2258065,
      size.width * 0.6660884,
      size.height * 0.2258065,
    );
    path_0.lineTo(size.width * 0.7778689, size.height * 0.2258065);
    path_0.cubicTo(
      size.width * 0.7921098,
      size.height * 0.2258065,
      size.width * 0.8056372,
      size.height * 0.2093468,
      size.width * 0.8149055,
      size.height * 0.1807476,
    );
    path_0.lineTo(size.width * 0.8552256, size.height * 0.05632395);
    path_0.cubicTo(
      size.width * 0.8668079,
      size.height * 0.02057460,
      size.width * 0.8837195,
      0,
      size.width * 0.9015213,
      0,
    );
    path_0.lineTo(size.width * 0.9634146, 0);
    path_0.cubicTo(
      size.width * 0.9836189,
      0,
      size.width,
      size.height * 0.04332726,
      size.width,
      size.height * 0.09677419,
    );
    path_0.lineTo(size.width, size.height * 0.8991935);
    path_0.cubicTo(
      size.width,
      size.height * 0.9526371,
      size.width * 0.9836189,
      size.height * 0.9959677,
      size.width * 0.9634146,
      size.height * 0.9959677,
    );
    path_0.lineTo(size.width * 0.03658537, size.height * 0.9959677);
    path_0.cubicTo(
      size.width * 0.01637985,
      size.height * 0.9959677,
      0,
      size.height * 0.9526371,
      0,
      size.height * 0.8991935,
    );
    path_0.lineTo(0, size.height * 0.09677419);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, 0),
      Offset(size.width * 0.5000000, size.height * 0.9959677),
      [Color(0xffE8FAFE).withOpacity(1), Colors.white.withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(0, size.height * 0.09677419);
    path_1.cubicTo(
      0,
      size.height * 0.04332726,
      size.width * 0.01637982,
      0,
      size.width * 0.03658537,
      0,
    );
    path_1.lineTo(size.width * 0.5389604, 0);
    path_1.cubicTo(
      size.width * 0.5559146,
      0,
      size.width * 0.5721037,
      size.height * 0.01867452,
      size.width * 0.5836402,
      size.height * 0.05154016,
    );
    path_1.lineTo(size.width * 0.6303415, size.height * 0.1845742);
    path_1.cubicTo(
      size.width * 0.6395732,
      size.height * 0.2108669,
      size.width * 0.6525244,
      size.height * 0.2258065,
      size.width * 0.6660884,
      size.height * 0.2258065,
    );
    path_1.lineTo(size.width * 0.7778689, size.height * 0.2258065);
    path_1.cubicTo(
      size.width * 0.7921098,
      size.height * 0.2258065,
      size.width * 0.8056372,
      size.height * 0.2093468,
      size.width * 0.8149055,
      size.height * 0.1807476,
    );
    path_1.lineTo(size.width * 0.8552256, size.height * 0.05632395);
    path_1.cubicTo(
      size.width * 0.8668079,
      size.height * 0.02057460,
      size.width * 0.8837195,
      0,
      size.width * 0.9015213,
      0,
    );
    path_1.lineTo(size.width * 0.9634146, 0);
    path_1.cubicTo(
      size.width * 0.9836189,
      0,
      size.width,
      size.height * 0.04332726,
      size.width,
      size.height * 0.09677419,
    );
    path_1.lineTo(size.width, size.height * 0.8991935);
    path_1.cubicTo(
      size.width,
      size.height * 0.9526371,
      size.width * 0.9836189,
      size.height * 0.9959677,
      size.width * 0.9634146,
      size.height * 0.9959677,
    );
    path_1.lineTo(size.width * 0.03658537, size.height * 0.9959677);
    path_1.cubicTo(
      size.width * 0.01637985,
      size.height * 0.9959677,
      0,
      size.height * 0.9526371,
      0,
      size.height * 0.8991935,
    );
    path_1.lineTo(0, size.height * 0.09677419);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.5000000, 0),
      Offset(size.width * 0.5000000, size.height * 0.9979839),
      [
        Color(0xff90E1F2).withOpacity(1),
        Color(0xffD7FFDE).withOpacity(1),
        Colors.white.withOpacity(1),
      ],
      [0, 0.690665, 1],
    );
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.07523963, size.height * 0.6369210);
    path_2.cubicTo(
      size.width * 0.07215884,
      size.height * 0.6395347,
      size.width * 0.06963079,
      size.height * 0.6452669,
      size.width * 0.06822805,
      size.height * 0.6529782,
    );
    path_2.cubicTo(
      size.width * 0.06682470,
      size.height * 0.6606831,
      size.width * 0.06666128,
      size.height * 0.6697363,
      size.width * 0.06775793,
      size.height * 0.6780242,
    );
    path_2.cubicTo(
      size.width * 0.06885427,
      size.height * 0.6863121,
      size.width * 0.07111646,
      size.height * 0.6931194,
      size.width * 0.07403018,
      size.height * 0.6968274,
    );
    path_2.cubicTo(
      size.width * 0.07694482,
      size.height * 0.7005427,
      size.width * 0.08027226,
      size.height * 0.7008532,
      size.width * 0.08329695,
      size.height * 0.6978145,
    );
    path_2.cubicTo(
      size.width * 0.08779024,
      size.height * 0.6932992,
      size.width * 0.09231524,
      size.height * 0.6888694,
      size.width * 0.09687866,
      size.height * 0.6844960,
    );
    path_2.cubicTo(
      size.width * 0.1148598,
      size.height * 0.6673097,
      size.width * 0.1330174,
      size.height * 0.6511371,
      size.width * 0.1512628,
      size.height * 0.6370694,
    );
    path_2.cubicTo(
      size.width * 0.1603652,
      size.height * 0.6300992,
      size.width * 0.1695006,
      size.height * 0.6236153,
      size.width * 0.1785805,
      size.height * 0.6186508,
    );
    path_2.cubicTo(
      size.width * 0.1830884,
      size.height * 0.6162121,
      size.width * 0.1876088,
      size.height * 0.6141387,
      size.width * 0.1917823,
      size.height * 0.6131895,
    );
    path_2.cubicTo(
      size.width * 0.1938088,
      size.height * 0.6127218,
      size.width * 0.1958948,
      size.height * 0.6125976,
      size.width * 0.1972628,
      size.height * 0.6129532,
    );
    path_2.cubicTo(
      size.width * 0.1979165,
      size.height * 0.6130742,
      size.width * 0.1984421,
      size.height * 0.6135274,
      size.width * 0.1981543,
      size.height * 0.6131331,
    );
    path_2.cubicTo(
      size.width * 0.1979988,
      size.height * 0.6128645,
      size.width * 0.1976183,
      size.height * 0.6123935,
      size.width * 0.1969915,
      size.height * 0.6106048,
    );
    path_2.cubicTo(
      size.width * 0.1964055,
      size.height * 0.6089839,
      size.width * 0.1957521,
      size.height * 0.6057597,
      size.width * 0.1956040,
      size.height * 0.6029863,
    );
    path_2.cubicTo(
      size.width * 0.1976826,
      size.height * 0.6169597,
      size.width * 0.1864302,
      size.height * 0.6500637,
      size.width * 0.1761369,
      size.height * 0.6656831,
    );
    path_2.cubicTo(
      size.width * 0.1755835,
      size.height * 0.6665815,
      size.width * 0.1749805,
      size.height * 0.6672710,
      size.width * 0.1738271,
      size.height * 0.6704290,
    );
    path_2.cubicTo(
      size.width * 0.1735387,
      size.height * 0.6712621,
      size.width * 0.1732107,
      size.height * 0.6723097,
      size.width * 0.1728665,
      size.height * 0.6737992,
    );
    path_2.cubicTo(
      size.width * 0.1726951,
      size.height * 0.6745444,
      size.width * 0.1725210,
      size.height * 0.6754032,
      size.width * 0.1723573,
      size.height * 0.6764073,
    );
    path_2.cubicTo(
      size.width * 0.1722756,
      size.height * 0.6769097,
      size.width * 0.1721970,
      size.height * 0.6774476,
      size.width * 0.1721241,
      size.height * 0.6780234,
    );
    path_2.cubicTo(
      size.width * 0.1720854,
      size.height * 0.6783331,
      size.width * 0.1720601,
      size.height * 0.6785395,
      size.width * 0.1720125,
      size.height * 0.6789806,
    );
    path_2.cubicTo(
      size.width * 0.1719555,
      size.height * 0.6795145,
      size.width * 0.1719040,
      size.height * 0.6800774,
      size.width * 0.1718607,
      size.height * 0.6806669,
    );
    path_2.cubicTo(
      size.width * 0.1714488,
      size.height * 0.6853395,
      size.width * 0.1719497,
      size.height * 0.6921315,
      size.width * 0.1730534,
      size.height * 0.6961298,
    );
    path_2.cubicTo(
      size.width * 0.1741296,
      size.height * 0.7002476,
      size.width * 0.1752668,
      size.height * 0.7019960,
      size.width * 0.1760409,
      size.height * 0.7030645,
    );
    path_2.cubicTo(
      size.width * 0.1768366,
      size.height * 0.7041081,
      size.width * 0.1773963,
      size.height * 0.7045065,
      size.width * 0.1778506,
      size.height * 0.7048040,
    );
    path_2.cubicTo(
      size.width * 0.1779637,
      size.height * 0.7048750,
      size.width * 0.1780710,
      size.height * 0.7049363,
      size.width * 0.1781707,
      size.height * 0.7049887,
    );
    path_2.cubicTo(
      size.width * 0.1782067,
      size.height * 0.7050073,
      size.width * 0.1782421,
      size.height * 0.7050250,
      size.width * 0.1782768,
      size.height * 0.7050419,
    );
    path_2.cubicTo(
      size.width * 0.1783463,
      size.height * 0.7050758,
      size.width * 0.1784131,
      size.height * 0.7051056,
      size.width * 0.1784774,
      size.height * 0.7051331,
    );
    path_2.cubicTo(
      size.width * 0.1787354,
      size.height * 0.7052419,
      size.width * 0.1789579,
      size.height * 0.7053081,
      size.width * 0.1791616,
      size.height * 0.7053556,
    );
    path_2.cubicTo(
      size.width * 0.1795674,
      size.height * 0.7054492,
      size.width * 0.1799015,
      size.height * 0.7054718,
      size.width * 0.1802186,
      size.height * 0.7054742,
    );
    path_2.cubicTo(
      size.width * 0.1809488,
      size.height * 0.7054669,
      size.width * 0.1811607,
      size.height * 0.7054016,
      size.width * 0.1815436,
      size.height * 0.7053371,
    );
    path_2.cubicTo(
      size.width * 0.1818988,
      size.height * 0.7052685,
      size.width * 0.1822591,
      size.height * 0.7051815,
      size.width * 0.1826341,
      size.height * 0.7050798,
    );
    path_2.cubicTo(
      size.width * 0.1833848,
      size.height * 0.7048710,
      size.width * 0.1838256,
      size.height * 0.7047065,
      size.width * 0.1844777,
      size.height * 0.7044742,
    );
    path_2.cubicTo(
      size.width * 0.1847878,
      size.height * 0.7043613,
      size.width * 0.1851079,
      size.height * 0.7042403,
      size.width * 0.1854381,
      size.height * 0.7041129,
    );
    path_2.cubicTo(
      size.width * 0.1857122,
      size.height * 0.7040032,
      size.width * 0.1859753,
      size.height * 0.7038952,
      size.width * 0.1862540,
      size.height * 0.7037790,
    );
    path_2.cubicTo(
      size.width * 0.1886055,
      size.height * 0.7028040,
      size.width * 0.1908323,
      size.height * 0.7017379,
      size.width * 0.1929960,
      size.height * 0.7006661,
    );
    path_2.cubicTo(
      size.width * 0.1974582,
      size.height * 0.6984548,
      size.width * 0.2017744,
      size.height * 0.6961379,
      size.width * 0.2061369,
      size.height * 0.6937484,
    );
    path_2.cubicTo(
      size.width * 0.2148421,
      size.height * 0.6889677,
      size.width * 0.2235201,
      size.height * 0.6839653,
      size.width * 0.2321509,
      size.height * 0.6789105,
    );
    path_2.cubicTo(
      size.width * 0.2494381,
      size.height * 0.6687718,
      size.width * 0.2666915,
      size.height * 0.6583161,
      size.width * 0.2839174,
      size.height * 0.6477234,
    );
    path_2.cubicTo(
      size.width * 0.2886768,
      size.height * 0.6447927,
      size.width * 0.2935162,
      size.height * 0.6418073,
      size.width * 0.2981909,
      size.height * 0.6388863,
    );
    path_2.cubicTo(
      size.width * 0.2993415,
      size.height * 0.6381669,
      size.width * 0.3003470,
      size.height * 0.6362363,
      size.width * 0.3009896,
      size.height * 0.6335645,
    );
    path_2.cubicTo(
      size.width * 0.3016323,
      size.height * 0.6308911,
      size.width * 0.3018595,
      size.height * 0.6276960,
      size.width * 0.3016180,
      size.height * 0.6246355,
    );
    path_2.cubicTo(
      size.width * 0.3013765,
      size.height * 0.6215758,
      size.width * 0.3006848,
      size.height * 0.6188879,
      size.width * 0.2996912,
      size.height * 0.6171177,
    );
    path_2.cubicTo(
      size.width * 0.2986979,
      size.height * 0.6153508,
      size.width * 0.2974845,
      size.height * 0.6146452,
      size.width * 0.2963213,
      size.height * 0.6152040,
    );
    path_2.cubicTo(
      size.width * 0.2916152,
      size.height * 0.6174548,
      size.width * 0.2867247,
      size.height * 0.6197831,
      size.width * 0.2819232,
      size.height * 0.6220500,
    );
    path_2.cubicTo(
      size.width * 0.2645399,
      size.height * 0.6302532,
      size.width * 0.2471299,
      size.height * 0.6383194,
      size.width * 0.2297338,
      size.height * 0.6460435,
    );
    path_2.cubicTo(
      size.width * 0.2210512,
      size.height * 0.6498911,
      size.width * 0.2123271,
      size.height * 0.6536815,
      size.width * 0.2036424,
      size.height * 0.6572202,
    );
    path_2.cubicTo(
      size.width * 0.1992945,
      size.height * 0.6589871,
      size.width * 0.1949985,
      size.height * 0.6606782,
      size.width * 0.1906576,
      size.height * 0.6622234,
    );
    path_2.cubicTo(
      size.width * 0.1885598,
      size.height * 0.6629605,
      size.width * 0.1864049,
      size.height * 0.6636871,
      size.width * 0.1842918,
      size.height * 0.6642718,
    );
    path_2.cubicTo(
      size.width * 0.1838195,
      size.height * 0.6643976,
      size.width * 0.1832835,
      size.height * 0.6645379,
      size.width * 0.1827561,
      size.height * 0.6646597,
    );
    path_2.cubicTo(
      size.width * 0.1822226,
      size.height * 0.6647815,
      size.width * 0.1818659,
      size.height * 0.6648427,
      size.width * 0.1813604,
      size.height * 0.6649194,
    );
    path_2.cubicTo(
      size.width * 0.1808631,
      size.height * 0.6649927,
      size.width * 0.1805247,
      size.height * 0.6649895,
      size.width * 0.1804171,
      size.height * 0.6649492,
    );
    path_2.cubicTo(
      size.width * 0.1804180,
      size.height * 0.6649411,
      size.width * 0.1804750,
      size.height * 0.6649282,
      size.width * 0.1806451,
      size.height * 0.6649605,
    );
    path_2.cubicTo(
      size.width * 0.1807308,
      size.height * 0.6649782,
      size.width * 0.1808454,
      size.height * 0.6650081,
      size.width * 0.1810058,
      size.height * 0.6650734,
    );
    path_2.cubicTo(
      size.width * 0.1810695,
      size.height * 0.6651742,
      size.width * 0.1815186,
      size.height * 0.6649903,
      size.width * 0.1829634,
      size.height * 0.6667815,
    );
    path_2.cubicTo(
      size.width * 0.1836634,
      size.height * 0.6677508,
      size.width * 0.1847479,
      size.height * 0.6693879,
      size.width * 0.1857921,
      size.height * 0.6733815,
    );
    path_2.cubicTo(
      size.width * 0.1868643,
      size.height * 0.6772548,
      size.width * 0.1873546,
      size.height * 0.6839089,
      size.width * 0.1869537,
      size.height * 0.6884306,
    );
    path_2.cubicTo(
      size.width * 0.1869116,
      size.height * 0.6890016,
      size.width * 0.1868619,
      size.height * 0.6895452,
      size.width * 0.1868070,
      size.height * 0.6900597,
    );
    path_2.cubicTo(
      size.width * 0.1867613,
      size.height * 0.6904855,
      size.width * 0.1867369,
      size.height * 0.6906831,
      size.width * 0.1866997,
      size.height * 0.6909806,
    );
    path_2.cubicTo(
      size.width * 0.1866296,
      size.height * 0.6915339,
      size.width * 0.1865543,
      size.height * 0.6920492,
      size.width * 0.1864762,
      size.height * 0.6925282,
    );
    path_2.cubicTo(
      size.width * 0.1863204,
      size.height * 0.6934863,
      size.width * 0.1861555,
      size.height * 0.6942976,
      size.width * 0.1859954,
      size.height * 0.6949944,
    );
    path_2.cubicTo(
      size.width * 0.1856735,
      size.height * 0.6963863,
      size.width * 0.1853753,
      size.height * 0.6973331,
      size.width * 0.1851241,
      size.height * 0.6980597,
    );
    path_2.cubicTo(
      size.width * 0.1841189,
      size.height * 0.7007935,
      size.width * 0.1837826,
      size.height * 0.7009847,
      size.width * 0.1836192,
      size.height * 0.7013105,
    );
    path_2.cubicTo(
      size.width * 0.1906750,
      size.height * 0.6912282,
      size.width * 0.1968716,
      size.height * 0.6794395,
      size.width * 0.2026326,
      size.height * 0.6638065,
    );
    path_2.cubicTo(
      size.width * 0.2079921,
      size.height * 0.6484750,
      size.width * 0.2146137,
      size.height * 0.6266435,
      size.width * 0.2129326,
      size.height * 0.5946524,
    );
    path_2.cubicTo(
      size.width * 0.2121924,
      size.height * 0.5817831,
      size.width * 0.2080671,
      size.height * 0.5732363,
      size.width * 0.2058287,
      size.height * 0.5706484,
    );
    path_2.cubicTo(
      size.width * 0.2033704,
      size.height * 0.5675363,
      size.width * 0.2014674,
      size.height * 0.5666040,
      size.width * 0.1997698,
      size.height * 0.5658355,
    );
    path_2.cubicTo(
      size.width * 0.1963887,
      size.height * 0.5644637,
      size.width * 0.1935064,
      size.height * 0.5644944,
      size.width * 0.1907881,
      size.height * 0.5646839,
    );
    path_2.cubicTo(
      size.width * 0.1853143,
      size.height * 0.5651823,
      size.width * 0.1802582,
      size.height * 0.5668766,
      size.width * 0.1752460,
      size.height * 0.5688605,
    );
    path_2.cubicTo(
      size.width * 0.1652241,
      size.height * 0.5729298,
      size.width * 0.1556079,
      size.height * 0.5783895,
      size.width * 0.1460387,
      size.height * 0.5843048,
    );
    path_2.cubicTo(
      size.width * 0.1268960,
      size.height * 0.5962589,
      size.width * 0.1081223,
      size.height * 0.6101702,
      size.width * 0.08941524,
      size.height * 0.6251960,
    );
    path_2.cubicTo(
      size.width * 0.08466677,
      size.height * 0.6290234,
      size.width * 0.07995213,
      size.height * 0.6329145,
      size.width * 0.07523963,
      size.height * 0.6369210,
    );
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(
      Offset(size.width * 0.07926829, size.height * 0.6369613),
      Offset(size.width * 0.2972561, size.height * 0.6369613),
      [Color(0xff06DDA0).withOpacity(1), Color(0xff88FF88).withOpacity(1)],
      [0, 1],
    );
    canvas.drawPath(path_2, paint_2_fill);

    Path path_3 = Path();
    path_3.moveTo(size.width * 0.6539634, size.height * 0.7983871);
    path_3.cubicTo(
      size.width * 0.6112805,
      size.height * 0.9112903,
      size.width * 0.4409695,
      size.height * 0.9661290,
      size.width * 0.4360915,
      size.height * 0.7983871,
    );
    path_3.cubicTo(
      size.width * 0.4336037,
      size.height * 0.7128468,
      size.width * 0.4718201,
      size.height * 0.6366734,
      size.width * 0.5016402,
      size.height * 0.5967750,
    );
    path_3.moveTo(size.width * 0.9269451, size.height * 0.4717750);
    path_3.cubicTo(
      size.width * 0.9729665,
      size.height * 0.3545258,
      size.width * 1.012808,
      size.height * 0.2209742,
      size.width * 1.027439,
      size.height * 0.05645161,
    );

    Paint paint_3_stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.03658537;
    paint_3_stroke.strokeCap = StrokeCap.round;
    paint_3_stroke.strokeJoin = StrokeJoin.round;
    paint_3_stroke.shader = ui.Gradient.linear(
      Offset(size.width * 0.7180122, size.height * 0.8910081),
      Offset(size.width * 0.7180122, size.height * 0.08467742),
      [Color(0xff44F75C).withOpacity(1), Color(0xff08A1F9).withOpacity(1)],
      [0, 1],
    );
    canvas.save();
    canvas.clipPath(path_1); // path_1 là path nền đã bo góc
    canvas.drawPath(path_3, paint_3_stroke);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
