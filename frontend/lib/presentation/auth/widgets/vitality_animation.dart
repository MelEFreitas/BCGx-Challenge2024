import 'package:flutter/material.dart';
import 'package:frontend/core/constants/theme.dart';
import 'package:vitality/vitality.dart';

class VitalityBackground extends StatelessWidget {
  const VitalityBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Vitality.randomly(
      background: ThemeColors.lightGrey, 
      maxOpacity: 0.8,                      
      minOpacity: 0.3,                      
      itemsCount: 40,                        
      enableXMovements: true,                
      whenOutOfScreenMode: WhenOutOfScreenMode.Teleport, 
      maxSpeed: 1.0,                         
      minSpeed: 0.5,                         
      maxSize: 30,                           
      randomItemsColors: const [
        ThemeColors.logoGreen,
        ThemeColors.logoOrange,
        ThemeColors.lightGreen,
        ThemeColors.lightOrange,
      ],
      randomItemsBehaviours: [
        ItemBehaviour(shape: ShapeType.Icon, icon: Icons.star_border), 
        ItemBehaviour(shape: ShapeType.StrokeCircle),                 
        ItemBehaviour(shape: ShapeType.DoubleStrokeCircle),            
        ItemBehaviour(shape: ShapeType.Icon, icon: Icons.circle),      
      ],
    );
  }
}
