
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

LineChartData activityData() {
    return LineChartData(
      gridData: FlGridData(
        show: false,
        drawVerticalLine: true,
      ),
      titlesData: FlTitlesData(
        show: false,
        // leftTitles: SideTitles(
        //   showTitles: false, 
        // ),
      ),
      borderData: FlBorderData(
          show: false,
      ),
      minX: 0,
      maxX: 12,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(0, 3),
            FlSpot(2, 2),
            FlSpot(4, 5),
            FlSpot(6, 3.1),
            FlSpot(8, 4),
            FlSpot(10, 3),
            FlSpot(12, 4),
            
          ],
          
          isCurved: true,
          color:Colors.white,
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            color: Color(0xFF4d79fe).withOpacity(0.3),
          ),
        ),
      ],
    );
  }