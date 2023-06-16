//
//  GeocacheIcons.swift
//  WatchyGPS
//
//  Created by Ben Goldberg on 7/15/22.
//

import SwiftUI

// from geocaching.com
struct TraditionalCacheShape: Shape {
    static var color: UInt = 0x02874d
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.77979*width, y: 0.34258*height))
        path.addCurve(to: CGPoint(x: 0.5309*width, y: 0.33352*height), control1: CGPoint(x: 0.76233*width, y: 0.33319*height), control2: CGPoint(x: 0.5309*width, y: 0.33352*height))
        path.addLine(to: CGPoint(x: 0.21596*width, y: 0.41025*height))
        path.addCurve(to: CGPoint(x: 0.20831*width, y: 0.42558*height), control1: CGPoint(x: 0.20831*width, y: 0.42558*height), control2: CGPoint(x: 0.20831*width, y: 0.41217*height))
        path.addLine(to: CGPoint(x: 0.20831*width, y: 0.46556*height))
        path.addCurve(to: CGPoint(x: 0.22108*width, y: 0.47935*height), control1: CGPoint(x: 0.20831*width, y: 0.48031*height), control2: CGPoint(x: 0.22108*width, y: 0.47935*height))
        path.addLine(to: CGPoint(x: 0.22602*width, y: 0.48037*height))
        path.addLine(to: CGPoint(x: 0.22602*width, y: 0.61981*height))
        path.addCurve(to: CGPoint(x: 0.27937*width, y: 0.68267*height), control1: CGPoint(x: 0.22602*width, y: 0.65437*height), control2: CGPoint(x: 0.24973*width, y: 0.68267*height))
        path.addLine(to: CGPoint(x: 0.45812*width, y: 0.68267*height))
        path.addCurve(to: CGPoint(x: 0.48258*width, y: 0.67548*height), control1: CGPoint(x: 0.46698*width, y: 0.68267*height), control2: CGPoint(x: 0.47519*width, y: 0.6799*height))
        path.addLine(to: CGPoint(x: 0.48269*width, y: 0.67579*height))
        path.addLine(to: CGPoint(x: 0.71377*width, y: 0.58008*height))
        path.addCurve(to: CGPoint(x: 0.76208*width, y: 0.50733*height), control1: CGPoint(x: 0.76125*width, y: 0.55869*height), control2: CGPoint(x: 0.76294*width, y: 0.54146*height))
        path.addCurve(to: CGPoint(x: 0.7619*width, y: 0.4941*height), control1: CGPoint(x: 0.76208*width, y: 0.50331*height), control2: CGPoint(x: 0.7619*width, y: 0.49892*height))
        path.addLine(to: CGPoint(x: 0.7619*width, y: 0.38812*height))
        path.addCurve(to: CGPoint(x: 0.7746*width, y: 0.38583*height), control1: CGPoint(x: 0.76542*width, y: 0.38688*height), control2: CGPoint(x: 0.77442*width, y: 0.38602*height))
        path.addCurve(to: CGPoint(x: 0.77996*width, y: 0.37702*height), control1: CGPoint(x: 0.77473*width, y: 0.38575*height), control2: CGPoint(x: 0.77996*width, y: 0.38392*height))
        path.addCurve(to: CGPoint(x: 0.77979*width, y: 0.34258*height), control1: CGPoint(x: 0.77996*width, y: 0.36867*height), control2: CGPoint(x: 0.77979*width, y: 0.35158*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.44975*width, y: 0.64558*height))
        path.addLine(to: CGPoint(x: 0.28831*width, y: 0.64558*height))
        path.addCurve(to: CGPoint(x: 0.26208*width, y: 0.611*height), control1: CGPoint(x: 0.27381*width, y: 0.64558*height), control2: CGPoint(x: 0.26208*width, y: 0.63008*height))
        path.addLine(to: CGPoint(x: 0.26208*width, y: 0.4804*height))
        path.addLine(to: CGPoint(x: 0.476*width, y: 0.4804*height))
        path.addLine(to: CGPoint(x: 0.476*width, y: 0.611*height))
        path.addCurve(to: CGPoint(x: 0.44975*width, y: 0.64558*height), control1: CGPoint(x: 0.476*width, y: 0.63006*height), control2: CGPoint(x: 0.46425*width, y: 0.64558*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.72633*width, y: 0.50052*height))
        path.addCurve(to: CGPoint(x: 0.69435*width, y: 0.54669*height), control1: CGPoint(x: 0.72696*width, y: 0.52781*height), control2: CGPoint(x: 0.72383*width, y: 0.53358*height))
        path.addLine(to: CGPoint(x: 0.51073*width, y: 0.62392*height))
        path.addCurve(to: CGPoint(x: 0.51175*width, y: 0.61156*height), control1: CGPoint(x: 0.51135*width, y: 0.6199*height), control2: CGPoint(x: 0.51175*width, y: 0.61577*height))
        path.addLine(to: CGPoint(x: 0.51188*width, y: 0.48037*height))
        path.addCurve(to: CGPoint(x: 0.52973*width, y: 0.47119*height), control1: CGPoint(x: 0.52973*width, y: 0.47119*height), control2: CGPoint(x: 0.52558*width, y: 0.4726*height))
        path.addCurve(to: CGPoint(x: 0.72606*width, y: 0.40108*height), control1: CGPoint(x: 0.56819*width, y: 0.458*height), control2: CGPoint(x: 0.67106*width, y: 0.42094*height))
        path.addLine(to: CGPoint(x: 0.72606*width, y: 0.4866*height))
        path.addCurve(to: CGPoint(x: 0.72633*width, y: 0.50052*height), control1: CGPoint(x: 0.72606*width, y: 0.49169*height), control2: CGPoint(x: 0.72617*width, y: 0.49631*height))
        path.closeSubpath()
        return path
    }
}

struct MultiCacheShape: Shape {
    static var color: UInt = 0xe98300
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.657*width, y: 0.43669*height))
        path.addCurve(to: CGPoint(x: 0.46958*width, y: 0.43669*height), control1: CGPoint(x: 0.5459*width, y: 0.43658*height), control2: CGPoint(x: 0.46958*width, y: 0.43669*height))
        path.addLine(to: CGPoint(x: 0.21831*width, y: 0.48429*height))
        path.addCurve(to: CGPoint(x: 0.21219*width, y: 0.49612*height), control1: CGPoint(x: 0.21219*width, y: 0.49612*height), control2: CGPoint(x: 0.21219*width, y: 0.48575*height))
        path.addLine(to: CGPoint(x: 0.21219*width, y: 0.51525*height))
        path.addCurve(to: CGPoint(x: 0.22192*width, y: 0.52596*height), control1: CGPoint(x: 0.21219*width, y: 0.52533*height), control2: CGPoint(x: 0.22*width, y: 0.52596*height))
        path.addLine(to: CGPoint(x: 0.22233*width, y: 0.52596*height))
        path.addLine(to: CGPoint(x: 0.23023*width, y: 0.5269*height))
        path.addLine(to: CGPoint(x: 0.23023*width, y: 0.64017*height))
        path.addCurve(to: CGPoint(x: 0.27308*width, y: 0.68908*height), control1: CGPoint(x: 0.23023*width, y: 0.66717*height), control2: CGPoint(x: 0.24948*width, y: 0.68908*height))
        path.addLine(to: CGPoint(x: 0.40969*width, y: 0.68908*height))
        path.addCurve(to: CGPoint(x: 0.42921*width, y: 0.68344*height), control1: CGPoint(x: 0.41675*width, y: 0.68908*height), control2: CGPoint(x: 0.42335*width, y: 0.6869*height))
        path.addLine(to: CGPoint(x: 0.42931*width, y: 0.68371*height))
        path.addLine(to: CGPoint(x: 0.60562*width, y: 0.61985*height))
        path.addCurve(to: CGPoint(x: 0.64431*width, y: 0.56342*height), control1: CGPoint(x: 0.64358*width, y: 0.60331*height), control2: CGPoint(x: 0.64431*width, y: 0.58775*height))
        path.addLine(to: CGPoint(x: 0.64425*width, y: 0.4729*height))
        path.addCurve(to: CGPoint(x: 0.65667*width, y: 0.47137*height), control1: CGPoint(x: 0.6471*width, y: 0.47183*height), control2: CGPoint(x: 0.65654*width, y: 0.47156*height))
        path.addCurve(to: CGPoint(x: 0.66137*width, y: 0.46454*height), control1: CGPoint(x: 0.65675*width, y: 0.47127*height), control2: CGPoint(x: 0.66137*width, y: 0.46985*height))
        path.addLine(to: CGPoint(x: 0.66137*width, y: 0.44188*height))
        path.addCurve(to: CGPoint(x: 0.657*width, y: 0.43669*height), control1: CGPoint(x: 0.6614*width, y: 0.43819*height), control2: CGPoint(x: 0.65721*width, y: 0.43669*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.3894*width, y: 0.65277*height))
        path.addLine(to: CGPoint(x: 0.2869*width, y: 0.65277*height))
        path.addCurve(to: CGPoint(x: 0.26625*width, y: 0.62619*height), control1: CGPoint(x: 0.27544*width, y: 0.65277*height), control2: CGPoint(x: 0.26625*width, y: 0.6411*height))
        path.addLine(to: CGPoint(x: 0.26625*width, y: 0.5269*height))
        path.addLine(to: CGPoint(x: 0.41025*width, y: 0.5269*height))
        path.addLine(to: CGPoint(x: 0.41031*width, y: 0.62579*height))
        path.addCurve(to: CGPoint(x: 0.3894*width, y: 0.65277*height), control1: CGPoint(x: 0.41031*width, y: 0.64073*height), control2: CGPoint(x: 0.4009*width, y: 0.65277*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.6085*width, y: 0.55104*height))
        path.addCurve(to: CGPoint(x: 0.58302*width, y: 0.58687*height), control1: CGPoint(x: 0.60827*width, y: 0.5629*height), control2: CGPoint(x: 0.60652*width, y: 0.57669*height))
        path.addLine(to: CGPoint(x: 0.44519*width, y: 0.63404*height))
        path.addCurve(to: CGPoint(x: 0.44625*width, y: 0.6259*height), control1: CGPoint(x: 0.44625*width, y: 0.6259*height), control2: CGPoint(x: 0.44625*width, y: 0.62923*height))
        path.addLine(to: CGPoint(x: 0.44625*width, y: 0.5269*height))
        path.addLine(to: CGPoint(x: 0.60825*width, y: 0.48271*height))
        path.addCurve(to: CGPoint(x: 0.6085*width, y: 0.55104*height), control1: CGPoint(x: 0.60831*width, y: 0.48933*height), control2: CGPoint(x: 0.60877*width, y: 0.53696*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.78194*width, y: 0.3366*height))
        path.addLine(to: CGPoint(x: 0.51825*width, y: 0.3109*height))
        path.addCurve(to: CGPoint(x: 0.32469*width, y: 0.33925*height), control1: CGPoint(x: 0.32469*width, y: 0.33925*height), control2: CGPoint(x: 0.3314*width, y: 0.33846*height))
        path.addCurve(to: CGPoint(x: 0.32031*width, y: 0.34508*height), control1: CGPoint(x: 0.32448*width, y: 0.33925*height), control2: CGPoint(x: 0.3204*width, y: 0.34123*height))
        path.addLine(to: CGPoint(x: 0.32031*width, y: 0.37458*height))
        path.addCurve(to: CGPoint(x: 0.32483*width, y: 0.3811*height), control1: CGPoint(x: 0.32031*width, y: 0.38006*height), control2: CGPoint(x: 0.32481*width, y: 0.38102*height))
        path.addCurve(to: CGPoint(x: 0.33842*width, y: 0.38256*height), control1: CGPoint(x: 0.3251*width, y: 0.38123*height), control2: CGPoint(x: 0.33565*width, y: 0.38173*height))
        path.addLine(to: CGPoint(x: 0.34337*width, y: 0.3829*height))
        path.addLine(to: CGPoint(x: 0.33823*width, y: 0.3829*height))
        path.addLine(to: CGPoint(x: 0.33829*width, y: 0.4169*height))
        path.addLine(to: CGPoint(x: 0.37437*width, y: 0.41206*height))
        path.addLine(to: CGPoint(x: 0.37425*width, y: 0.38502*height))
        path.addLine(to: CGPoint(x: 0.59242*width, y: 0.39996*height))
        path.addCurve(to: CGPoint(x: 0.61794*width, y: 0.40069*height), control1: CGPoint(x: 0.61794*width, y: 0.40069*height), control2: CGPoint(x: 0.60837*width, y: 0.40069*height))
        path.addCurve(to: CGPoint(x: 0.62365*width, y: 0.4005*height), control1: CGPoint(x: 0.6204*width, y: 0.40069*height), control2: CGPoint(x: 0.62242*width, y: 0.40063*height))
        path.addCurve(to: CGPoint(x: 0.73446*width, y: 0.38785*height), control1: CGPoint(x: 0.67025*width, y: 0.39602*height), control2: CGPoint(x: 0.70796*width, y: 0.39142*height))
        path.addLine(to: CGPoint(x: 0.73435*width, y: 0.47192*height))
        path.addCurve(to: CGPoint(x: 0.71363*width, y: 0.49042*height), control1: CGPoint(x: 0.73435*width, y: 0.48702*height), control2: CGPoint(x: 0.72504*width, y: 0.48935*height))
        path.addLine(to: CGPoint(x: 0.67973*width, y: 0.49685*height))
        path.addCurve(to: CGPoint(x: 0.67992*width, y: 0.50421*height), control1: CGPoint(x: 0.67975*width, y: 0.50023*height), control2: CGPoint(x: 0.67979*width, y: 0.50125*height))
        path.addCurve(to: CGPoint(x: 0.67994*width, y: 0.52696*height), control1: CGPoint(x: 0.68002*width, y: 0.50875*height), control2: CGPoint(x: 0.68006*width, y: 0.52306*height))
        path.addLine(to: CGPoint(x: 0.72771*width, y: 0.52052*height))
        path.addCurve(to: CGPoint(x: 0.77004*width, y: 0.46717*height), control1: CGPoint(x: 0.75108*width, y: 0.5184*height), control2: CGPoint(x: 0.77004*width, y: 0.49442*height))
        path.addLine(to: CGPoint(x: 0.77025*width, y: 0.38273*height))
        path.addLine(to: CGPoint(x: 0.77783*width, y: 0.38154*height))
        path.addCurve(to: CGPoint(x: 0.78792*width, y: 0.36975*height), control1: CGPoint(x: 0.78792*width, y: 0.36975*height), control2: CGPoint(x: 0.78792*width, y: 0.38133*height))
        path.addCurve(to: CGPoint(x: 0.78798*width, y: 0.34808*height), control1: CGPoint(x: 0.78792*width, y: 0.36404*height), control2: CGPoint(x: 0.78792*width, y: 0.35419*height))
        path.addCurve(to: CGPoint(x: 0.78194*width, y: 0.3366*height), control1: CGPoint(x: 0.78796*width, y: 0.33754*height), control2: CGPoint(x: 0.78194*width, y: 0.3366*height))
        path.closeSubpath()
        return path
    }
}

struct VirtualCacheShape: Shape {
    static var color: UInt = 0x009bbb
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.6564*width, y: 0.4039*height))
        path.addCurve(to: CGPoint(x: 0.6564*width, y: 0.4039*height), control1: CGPoint(x: 0.6564*width, y: 0.40606*height), control2: CGPoint(x: 0.6565*width, y: 0.40173*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.66954*width, y: 0.5959*height))
        path.addCurve(to: CGPoint(x: 0.72369*width, y: 0.4206*height), control1: CGPoint(x: 0.7419*width, y: 0.52783*height), control2: CGPoint(x: 0.75579*width, y: 0.42858*height))
        path.addCurve(to: CGPoint(x: 0.657*width, y: 0.46227*height), control1: CGPoint(x: 0.70102*width, y: 0.41498*height), control2: CGPoint(x: 0.68896*width, y: 0.43535*height))
        path.addCurve(to: CGPoint(x: 0.6564*width, y: 0.4039*height), control1: CGPoint(x: 0.6564*width, y: 0.44017*height), control2: CGPoint(x: 0.6564*width, y: 0.42202*height))
        path.addCurve(to: CGPoint(x: 0.50569*width, y: 0.23677*height), control1: CGPoint(x: 0.6564*width, y: 0.31398*height), control2: CGPoint(x: 0.61054*width, y: 0.23677*height))
        path.addCurve(to: CGPoint(x: 0.35292*width, y: 0.40846*height), control1: CGPoint(x: 0.40083*width, y: 0.23677*height), control2: CGPoint(x: 0.35292*width, y: 0.31073*height))
        path.addCurve(to: CGPoint(x: 0.34846*width, y: 0.46673*height), control1: CGPoint(x: 0.35298*width, y: 0.41033*height), control2: CGPoint(x: 0.3506*width, y: 0.43746*height))
        path.addCurve(to: CGPoint(x: 0.27631*width, y: 0.42058*height), control1: CGPoint(x: 0.31233*width, y: 0.43765*height), control2: CGPoint(x: 0.30023*width, y: 0.41465*height))
        path.addCurve(to: CGPoint(x: 0.34123*width, y: 0.60548*height), control1: CGPoint(x: 0.24267*width, y: 0.42894*height), control2: CGPoint(x: 0.2595*width, y: 0.53758*height))
        path.addLine(to: CGPoint(x: 0.34306*width, y: 0.60633*height))
        path.addCurve(to: CGPoint(x: 0.32785*width, y: 0.70142*height), control1: CGPoint(x: 0.34079*width, y: 0.64221*height), control2: CGPoint(x: 0.33633*width, y: 0.67654*height))
        path.addCurve(to: CGPoint(x: 0.42931*width, y: 0.72979*height), control1: CGPoint(x: 0.29802*width, y: 0.78875*height), control2: CGPoint(x: 0.40548*width, y: 0.72979*height))
        path.addCurve(to: CGPoint(x: 0.52183*width, y: 0.76321*height), control1: CGPoint(x: 0.45665*width, y: 0.72979*height), control2: CGPoint(x: 0.48344*width, y: 0.76283*height))
        path.addCurve(to: CGPoint(x: 0.60594*width, y: 0.72979*height), control1: CGPoint(x: 0.56215*width, y: 0.7636*height), control2: CGPoint(x: 0.5649*width, y: 0.74069*height))
        path.addCurve(to: CGPoint(x: 0.69004*width, y: 0.67965*height), control1: CGPoint(x: 0.6316*width, y: 0.72298*height), control2: CGPoint(x: 0.72273*width, y: 0.79483*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.42931*width, y: 0.41225*height))
        path.addCurve(to: CGPoint(x: 0.45454*width, y: 0.37046*height), control1: CGPoint(x: 0.42931*width, y: 0.38917*height), control2: CGPoint(x: 0.4406*width, y: 0.37046*height))
        path.addCurve(to: CGPoint(x: 0.47977*width, y: 0.41225*height), control1: CGPoint(x: 0.46848*width, y: 0.37046*height), control2: CGPoint(x: 0.47977*width, y: 0.38917*height))
        path.addCurve(to: CGPoint(x: 0.45454*width, y: 0.45404*height), control1: CGPoint(x: 0.47977*width, y: 0.43531*height), control2: CGPoint(x: 0.46848*width, y: 0.45404*height))
        path.addCurve(to: CGPoint(x: 0.42931*width, y: 0.41225*height), control1: CGPoint(x: 0.4406*width, y: 0.45404*height), control2: CGPoint(x: 0.42931*width, y: 0.43533*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.505*width, y: 0.52804*height))
        path.addCurve(to: CGPoint(x: 0.46144*width, y: 0.49671*height), control1: CGPoint(x: 0.48442*width, y: 0.52804*height), control2: CGPoint(x: 0.46144*width, y: 0.51054*height))
        path.addCurve(to: CGPoint(x: 0.505*width, y: 0.5009*height), control1: CGPoint(x: 0.46144*width, y: 0.48285*height), control2: CGPoint(x: 0.48442*width, y: 0.5009*height))
        path.addCurve(to: CGPoint(x: 0.54706*width, y: 0.49583*height), control1: CGPoint(x: 0.52558*width, y: 0.5009*height), control2: CGPoint(x: 0.54706*width, y: 0.48198*height))
        path.addCurve(to: CGPoint(x: 0.505*width, y: 0.52804*height), control1: CGPoint(x: 0.54706*width, y: 0.50969*height), control2: CGPoint(x: 0.52558*width, y: 0.52804*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.55546*width, y: 0.45404*height))
        path.addCurve(to: CGPoint(x: 0.53023*width, y: 0.41225*height), control1: CGPoint(x: 0.54152*width, y: 0.45404*height), control2: CGPoint(x: 0.53023*width, y: 0.43533*height))
        path.addCurve(to: CGPoint(x: 0.55546*width, y: 0.37046*height), control1: CGPoint(x: 0.53023*width, y: 0.38917*height), control2: CGPoint(x: 0.54152*width, y: 0.37046*height))
        path.addCurve(to: CGPoint(x: 0.58069*width, y: 0.41225*height), control1: CGPoint(x: 0.5694*width, y: 0.37046*height), control2: CGPoint(x: 0.58069*width, y: 0.38917*height))
        path.addCurve(to: CGPoint(x: 0.55546*width, y: 0.45404*height), control1: CGPoint(x: 0.58071*width, y: 0.43533*height), control2: CGPoint(x: 0.5694*width, y: 0.45404*height))
        path.closeSubpath()
        return path
    }
}

struct LetterboxHybridShape: Shape {
    static var color: UInt = 0x12508c
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.26*width, y: 0.34*height))
        path.addLine(to: CGPoint(x: 0.26*width, y: 0.35667*height))
        path.addLine(to: CGPoint(x: 0.44625*width, y: 0.48167*height))
        path.addLine(to: CGPoint(x: 0.47063*width, y: 0.49833*height))
        path.addLine(to: CGPoint(x: 0.50375*width, y: 0.52083*height))
        path.addLine(to: CGPoint(x: 0.53667*width, y: 0.49875*height))
        path.addLine(to: CGPoint(x: 0.56104*width, y: 0.48208*height))
        path.addLine(to: CGPoint(x: 0.74729*width, y: 0.35708*height))
        path.addLine(to: CGPoint(x: 0.74729*width, y: 0.34042*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.26*width, y: 0.39*height))
        path.addLine(to: CGPoint(x: 0.26*width, y: 0.60667*height))
        path.addLine(to: CGPoint(x: 0.42021*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.26*width, y: 0.39042*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.50375*width, y: 0.55667*height))
        path.addLine(to: CGPoint(x: 0.44458*width, y: 0.51625*height))
        path.addLine(to: CGPoint(x: 0.26*width, y: 0.64*height))
        path.addLine(to: CGPoint(x: 0.7475*width, y: 0.64*height))
        path.addLine(to: CGPoint(x: 0.5625*width, y: 0.51625*height))
        path.addLine(to: CGPoint(x: 0.50333*width, y: 0.55667*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.7475*width, y: 0.60667*height))
        path.addLine(to: CGPoint(x: 0.7475*width, y: 0.39*height))
        path.addLine(to: CGPoint(x: 0.58729*width, y: 0.5*height))
        path.addLine(to: CGPoint(x: 0.7475*width, y: 0.60708*height))
        path.closeSubpath()
        return path
    }
}

struct EventCacheShape: Shape {
    static var color: UInt = 0x90040b
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.70106*width, y: 0.30635*height))
        path.addLine(to: CGPoint(x: 0.29894*width, y: 0.30635*height))
        path.addCurve(to: CGPoint(x: 0.268*width, y: 0.33835*height), control1: CGPoint(x: 0.28185*width, y: 0.30635*height), control2: CGPoint(x: 0.268*width, y: 0.32069*height))
        path.addLine(to: CGPoint(x: 0.268*width, y: 0.61035*height))
        path.addCurve(to: CGPoint(x: 0.29894*width, y: 0.64235*height), control1: CGPoint(x: 0.268*width, y: 0.62802*height), control2: CGPoint(x: 0.28185*width, y: 0.64235*height))
        path.addLine(to: CGPoint(x: 0.51548*width, y: 0.64235*height))
        path.addLine(to: CGPoint(x: 0.51548*width, y: 0.77035*height))
        path.addLine(to: CGPoint(x: 0.63921*width, y: 0.64235*height))
        path.addLine(to: CGPoint(x: 0.70108*width, y: 0.64235*height))
        path.addCurve(to: CGPoint(x: 0.73202*width, y: 0.61035*height), control1: CGPoint(x: 0.71817*width, y: 0.64235*height), control2: CGPoint(x: 0.73202*width, y: 0.62802*height))
        path.addLine(to: CGPoint(x: 0.73202*width, y: 0.33835*height))
        path.addCurve(to: CGPoint(x: 0.70106*width, y: 0.30635*height), control1: CGPoint(x: 0.732*width, y: 0.32067*height), control2: CGPoint(x: 0.71815*width, y: 0.30635*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.36079*width, y: 0.49835*height))
        path.addLine(to: CGPoint(x: 0.56185*width, y: 0.49835*height))
        path.addLine(to: CGPoint(x: 0.56185*width, y: 0.53035*height))
        path.addLine(to: CGPoint(x: 0.36079*width, y: 0.53035*height))
        path.addLine(to: CGPoint(x: 0.36079*width, y: 0.49835*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.36079*width, y: 0.43435*height))
        path.addLine(to: CGPoint(x: 0.63919*width, y: 0.43435*height))
        path.addLine(to: CGPoint(x: 0.63919*width, y: 0.46635*height))
        path.addLine(to: CGPoint(x: 0.36079*width, y: 0.46635*height))
        path.addLine(to: CGPoint(x: 0.36079*width, y: 0.43435*height))
        path.closeSubpath()
        return path
    }
}

struct MysteryCacheShape: Shape {
    static var color: UInt = 0x12508c
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.48183*width, y: 0.24*height))
        path.addCurve(to: CGPoint(x: 0.30994*width, y: 0.37873*height), control1: CGPoint(x: 0.33706*width, y: 0.24*height), control2: CGPoint(x: 0.30988*width, y: 0.33537*height))
        path.addCurve(to: CGPoint(x: 0.39138*width, y: 0.44808*height), control1: CGPoint(x: 0.30994*width, y: 0.43075*height), control2: CGPoint(x: 0.34613*width, y: 0.44808*height))
        path.addCurve(to: CGPoint(x: 0.45471*width, y: 0.39606*height), control1: CGPoint(x: 0.43863*width, y: 0.44808*height), control2: CGPoint(x: 0.45471*width, y: 0.41417*height))
        path.addCurve(to: CGPoint(x: 0.40042*width, y: 0.34404*height), control1: CGPoint(x: 0.45471*width, y: 0.37796*height), control2: CGPoint(x: 0.44567*width, y: 0.34404*height))
        path.addCurve(to: CGPoint(x: 0.48185*width, y: 0.30935*height), control1: CGPoint(x: 0.40042*width, y: 0.32594*height), control2: CGPoint(x: 0.43008*width, y: 0.30935*height))
        path.addCurve(to: CGPoint(x: 0.56329*width, y: 0.37871*height), control1: CGPoint(x: 0.53615*width, y: 0.30935*height), control2: CGPoint(x: 0.56329*width, y: 0.34404*height))
        path.addCurve(to: CGPoint(x: 0.509*width, y: 0.46542*height), control1: CGPoint(x: 0.56329*width, y: 0.4134*height), control2: CGPoint(x: 0.55352*width, y: 0.42988*height))
        path.addCurve(to: CGPoint(x: 0.43662*width, y: 0.56946*height), control1: CGPoint(x: 0.45471*width, y: 0.50877*height), control2: CGPoint(x: 0.43662*width, y: 0.53477*height))
        path.addCurve(to: CGPoint(x: 0.43662*width, y: 0.60415*height), control1: CGPoint(x: 0.43658*width, y: 0.58679*height), control2: CGPoint(x: 0.43662*width, y: 0.59508*height))
        path.addCurve(to: CGPoint(x: 0.47281*width, y: 0.62148*height), control1: CGPoint(x: 0.43662*width, y: 0.61281*height), control2: CGPoint(x: 0.45473*width, y: 0.62148*height))
        path.addCurve(to: CGPoint(x: 0.509*width, y: 0.60415*height), control1: CGPoint(x: 0.49092*width, y: 0.62148*height), control2: CGPoint(x: 0.509*width, y: 0.61281*height))
        path.addCurve(to: CGPoint(x: 0.59044*width, y: 0.5001*height), control1: CGPoint(x: 0.509*width, y: 0.56792*height), control2: CGPoint(x: 0.50873*width, y: 0.55175*height))
        path.addCurve(to: CGPoint(x: 0.68996*width, y: 0.37871*height), control1: CGPoint(x: 0.67187*width, y: 0.44808*height), control2: CGPoint(x: 0.68996*width, y: 0.42206*height))
        path.addCurve(to: CGPoint(x: 0.48183*width, y: 0.24*height), control1: CGPoint(x: 0.68994*width, y: 0.32671*height), control2: CGPoint(x: 0.66279*width, y: 0.24*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.4725*width, y: 0.65585*height))
        path.addCurve(to: CGPoint(x: 0.41817*width, y: 0.70792*height), control1: CGPoint(x: 0.44248*width, y: 0.65585*height), control2: CGPoint(x: 0.41817*width, y: 0.67917*height))
        path.addCurve(to: CGPoint(x: 0.4725*width, y: 0.76*height), control1: CGPoint(x: 0.41817*width, y: 0.73667*height), control2: CGPoint(x: 0.4425*width, y: 0.76*height))
        path.addCurve(to: CGPoint(x: 0.52683*width, y: 0.70792*height), control1: CGPoint(x: 0.5025*width, y: 0.76*height), control2: CGPoint(x: 0.52683*width, y: 0.73669*height))
        path.addCurve(to: CGPoint(x: 0.4725*width, y: 0.65585*height), control1: CGPoint(x: 0.52683*width, y: 0.67915*height), control2: CGPoint(x: 0.5025*width, y: 0.65585*height))
        path.closeSubpath()
        return path
    }
}

struct EarthCacheShape: Shape {
    static var color: UInt = 0xefdd92
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.47829*width, y: 0.48108*height))
        path.addCurve(to: CGPoint(x: 0.50667*width, y: 0.28806*height), control1: CGPoint(x: 0.48015*width, y: 0.4144*height), control2: CGPoint(x: 0.4919*width, y: 0.33127*height))
        path.addLine(to: CGPoint(x: 0.50667*width, y: 0.10371*height))
        path.addCurve(to: CGPoint(x: 0.414*width, y: 0.56038*height), control1: CGPoint(x: 0.42067*width, y: 0.24521*height), control2: CGPoint(x: 0.41308*width, y: 0.47804*height))
        path.addLine(to: CGPoint(x: 0.47829*width, y: 0.48108*height))
        path.move(to: CGPoint(x: 0.52958*width, y: 0.26415*height))
        path.addCurve(to: CGPoint(x: 0.71258*width, y: 0.4645*height), control1: CGPoint(x: 0.62467*width, y: 0.26788*height), control2: CGPoint(x: 0.70721*width, y: 0.38319*height))
        path.addLine(to: CGPoint(x: 0.90702*width, y: 0.49442*height))
        path.addLine(to: CGPoint(x: 0.90748*width, y: 0.49406*height))
        path.addCurve(to: CGPoint(x: 0.52958*width, y: 0.08721*height), control1: CGPoint(x: 0.9041*width, y: 0.27923*height), control2: CGPoint(x: 0.7386*width, y: 0.10385*height))
        path.addLine(to: CGPoint(x: 0.52958*width, y: 0.26415*height))
        path.move(to: CGPoint(x: 0.68933*width, y: 0.48435*height))
        path.addCurve(to: CGPoint(x: 0.49044*width, y: 0.50271*height), control1: CGPoint(x: 0.63227*width, y: 0.50725*height), control2: CGPoint(x: 0.5404*width, y: 0.51531*height))
        path.addLine(to: CGPoint(x: 0.42408*width, y: 0.5845*height))
        path.addCurve(to: CGPoint(x: 0.5645*width, y: 0.59892*height), control1: CGPoint(x: 0.44952*width, y: 0.59002*height), control2: CGPoint(x: 0.50079*width, y: 0.59892*height))
        path.addCurve(to: CGPoint(x: 0.8789*width, y: 0.51352*height), control1: CGPoint(x: 0.6469*width, y: 0.59892*height), control2: CGPoint(x: 0.77077*width, y: 0.58198*height))
        path.addLine(to: CGPoint(x: 0.68933*width, y: 0.48435*height))
        path.move(to: CGPoint(x: 0.5645*width, y: 0.6221*height))
        path.addCurve(to: CGPoint(x: 0.4005*width, y: 0.60275*height), control1: CGPoint(x: 0.46981*width, y: 0.6221*height), control2: CGPoint(x: 0.40327*width, y: 0.60356*height))
        path.addLine(to: CGPoint(x: 0.39269*width, y: 0.60054*height))
        path.addLine(to: CGPoint(x: 0.39215*width, y: 0.59237*height))
        path.addCurve(to: CGPoint(x: 0.49073*width, y: 0.08569*height), control1: CGPoint(x: 0.39125*width, y: 0.57888*height), control2: CGPoint(x: 0.37727*width, y: 0.26458*height))
        path.addCurve(to: CGPoint(x: 0.0866*width, y: 0.50077*height), control1: CGPoint(x: 0.26733*width, y: 0.08917*height), control2: CGPoint(x: 0.0866*width, y: 0.27398*height))
        path.addCurve(to: CGPoint(x: 0.4971*width, y: 0.91606*height), control1: CGPoint(x: 0.0866*width, y: 0.72981*height), control2: CGPoint(x: 0.27075*width, y: 0.91606*height))
        path.addCurve(to: CGPoint(x: 0.90704*width, y: 0.5229*height), control1: CGPoint(x: 0.71615*width, y: 0.91606*height), control2: CGPoint(x: 0.89567*width, y: 0.74163*height))
        path.addCurve(to: CGPoint(x: 0.5645*width, y: 0.6221*height), control1: CGPoint(x: 0.7905*width, y: 0.60308*height), control2: CGPoint(x: 0.65412*width, y: 0.6221*height))
        path.move(to: CGPoint(x: 0.52958*width, y: 0.26415*height))
        path.addCurve(to: CGPoint(x: 0.71258*width, y: 0.4645*height), control1: CGPoint(x: 0.62467*width, y: 0.26788*height), control2: CGPoint(x: 0.70721*width, y: 0.38319*height))
        path.addLine(to: CGPoint(x: 0.789*width, y: 0.47625*height))
        path.addCurve(to: CGPoint(x: 0.52956*width, y: 0.20362*height), control1: CGPoint(x: 0.784*width, y: 0.33802*height), control2: CGPoint(x: 0.66585*width, y: 0.20885*height))
        path.addLine(to: CGPoint(x: 0.52956*width, y: 0.26415*height))
        path.move(to: CGPoint(x: 0.68933*width, y: 0.48435*height))
        path.addCurve(to: CGPoint(x: 0.49044*width, y: 0.50271*height), control1: CGPoint(x: 0.63227*width, y: 0.50725*height), control2: CGPoint(x: 0.5404*width, y: 0.51531*height))
        path.addLine(to: CGPoint(x: 0.46529*width, y: 0.53371*height))
        path.addCurve(to: CGPoint(x: 0.76927*width, y: 0.49665*height), control1: CGPoint(x: 0.56165*width, y: 0.55779*height), control2: CGPoint(x: 0.67921*width, y: 0.54408*height))
        path.addLine(to: CGPoint(x: 0.68933*width, y: 0.48435*height))
        path.move(to: CGPoint(x: 0.50667*width, y: 0.2271*height))
        path.addCurve(to: CGPoint(x: 0.45731*width, y: 0.507*height), control1: CGPoint(x: 0.47962*width, y: 0.28285*height), control2: CGPoint(x: 0.45981*width, y: 0.39127*height))
        path.addLine(to: CGPoint(x: 0.47827*width, y: 0.48108*height))
        path.addCurve(to: CGPoint(x: 0.50665*width, y: 0.28806*height), control1: CGPoint(x: 0.48012*width, y: 0.4144*height), control2: CGPoint(x: 0.49188*width, y: 0.33127*height))
        path.addLine(to: CGPoint(x: 0.50665*width, y: 0.2271*height))
        path.move(to: CGPoint(x: 0.08679*width, y: 0.49342*height))
        path.addCurve(to: CGPoint(x: 0.1706*width, y: 0.38877*height), control1: CGPoint(x: 0.11792*width, y: 0.49435*height), control2: CGPoint(x: 0.16877*width, y: 0.42394*height))
        path.addCurve(to: CGPoint(x: 0.205*width, y: 0.34625*height), control1: CGPoint(x: 0.17252*width, y: 0.35208*height), control2: CGPoint(x: 0.18588*width, y: 0.35015*height))
        path.addCurve(to: CGPoint(x: 0.28325*width, y: 0.35979*height), control1: CGPoint(x: 0.22408*width, y: 0.34244*height), control2: CGPoint(x: 0.25846*width, y: 0.37138*height))
        path.addCurve(to: CGPoint(x: 0.34056*width, y: 0.29992*height), control1: CGPoint(x: 0.3081*width, y: 0.34821*height), control2: CGPoint(x: 0.33865*width, y: 0.30958*height))
        path.addCurve(to: CGPoint(x: 0.33673*width, y: 0.21104*height), control1: CGPoint(x: 0.34246*width, y: 0.29023*height), control2: CGPoint(x: 0.35583*width, y: 0.24971*height))
        path.addCurve(to: CGPoint(x: 0.33704*width, y: 0.11837*height), control1: CGPoint(x: 0.32256*width, y: 0.1824*height), control2: CGPoint(x: 0.3315*width, y: 0.13898*height))
        path.addCurve(to: CGPoint(x: 0.08679*width, y: 0.49342*height), control1: CGPoint(x: 0.19212*width, y: 0.18071*height), control2: CGPoint(x: 0.08971*width, y: 0.325*height))
        path.move(to: CGPoint(x: 0.85388*width, y: 0.55465*height))
        path.addCurve(to: CGPoint(x: 0.78354*width, y: 0.69975*height), control1: CGPoint(x: 0.85169*width, y: 0.5786*height), control2: CGPoint(x: 0.83692*width, y: 0.71325*height))
        path.addCurve(to: CGPoint(x: 0.61169*width, y: 0.6669*height), control1: CGPoint(x: 0.73008*width, y: 0.68623*height), control2: CGPoint(x: 0.65617*width, y: 0.63588*height))
        path.addCurve(to: CGPoint(x: 0.58688*width, y: 0.76152*height), control1: CGPoint(x: 0.55633*width, y: 0.70554*height), control2: CGPoint(x: 0.60977*width, y: 0.73452*height))
        path.addCurve(to: CGPoint(x: 0.57542*width, y: 0.85813*height), control1: CGPoint(x: 0.56394*width, y: 0.78858*height), control2: CGPoint(x: 0.57925*width, y: 0.83106*height))
        path.addCurve(to: CGPoint(x: 0.55383*width, y: 0.91202*height), control1: CGPoint(x: 0.57221*width, y: 0.8809*height), control2: CGPoint(x: 0.55819*width, y: 0.90496*height))
        path.addCurve(to: CGPoint(x: 0.90685*width, y: 0.52302*height), control1: CGPoint(x: 0.74633*width, y: 0.88496*height), control2: CGPoint(x: 0.8964*width, y: 0.72246*height))
        path.addCurve(to: CGPoint(x: 0.85388*width, y: 0.55465*height), control1: CGPoint(x: 0.88956*width, y: 0.53492*height), control2: CGPoint(x: 0.87181*width, y: 0.54531*height))
        return path
    }
}

struct WherigoShape: Shape {
    static var color: UInt = 0x12508c
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.5119*width, y: 0.254*height))
        path.addCurve(to: CGPoint(x: 0.26815*width, y: 0.49094*height), control1: CGPoint(x: 0.37729*width, y: 0.254*height), control2: CGPoint(x: 0.26815*width, y: 0.3601*height))
        path.addCurve(to: CGPoint(x: 0.5119*width, y: 0.7279*height), control1: CGPoint(x: 0.26815*width, y: 0.62181*height), control2: CGPoint(x: 0.37731*width, y: 0.7279*height))
        path.addCurve(to: CGPoint(x: 0.75567*width, y: 0.49094*height), control1: CGPoint(x: 0.64652*width, y: 0.7279*height), control2: CGPoint(x: 0.75567*width, y: 0.62181*height))
        path.addCurve(to: CGPoint(x: 0.5119*width, y: 0.254*height), control1: CGPoint(x: 0.75565*width, y: 0.3601*height), control2: CGPoint(x: 0.64652*width, y: 0.254*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.52058*width, y: 0.58342*height))
        path.addLine(to: CGPoint(x: 0.41352*width, y: 0.47929*height))
        path.addLine(to: CGPoint(x: 0.59881*width, y: 0.40325*height))
        path.addLine(to: CGPoint(x: 0.52058*width, y: 0.58342*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.52512*width, y: 0.19*height))
        path.addLine(to: CGPoint(x: 0.52142*width, y: 0.2456*height))
        path.addCurve(to: CGPoint(x: 0.6685*width, y: 0.29644*height), control1: CGPoint(x: 0.57473*width, y: 0.24871*height), control2: CGPoint(x: 0.62527*width, y: 0.26631*height))
        path.addLine(to: CGPoint(x: 0.70344*width, y: 0.25171*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.73983*width, y: 0.28108*height))
        path.addLine(to: CGPoint(x: 0.68898*width, y: 0.3121*height))
        path.addCurve(to: CGPoint(x: 0.6996*width, y: 0.32106*height), control1: CGPoint(x: 0.69252*width, y: 0.31508*height), control2: CGPoint(x: 0.69617*width, y: 0.31792*height))
        path.addCurve(to: CGPoint(x: 0.70735*width, y: 0.32902*height), control1: CGPoint(x: 0.70235*width, y: 0.32362*height), control2: CGPoint(x: 0.70475*width, y: 0.3264*height))
        path.addLine(to: CGPoint(x: 0.75021*width, y: 0.29169*height))
        path.addCurve(to: CGPoint(x: 0.73983*width, y: 0.28108*height), control1: CGPoint(x: 0.74671*width, y: 0.28821*height), control2: CGPoint(x: 0.74352*width, y: 0.28448*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.72452*width, y: 0.34785*height))
        path.addCurve(to: CGPoint(x: 0.78383*width, y: 0.48444*height), control1: CGPoint(x: 0.75806*width, y: 0.38831*height), control2: CGPoint(x: 0.77802*width, y: 0.43579*height))
        path.addLine(to: CGPoint(x: 0.79558*width, y: 0.48362*height))
        path.addCurve(to: CGPoint(x: 0.73106*width, y: 0.35275*height), control1: CGPoint(x: 0.78854*width, y: 0.42979*height), control2: CGPoint(x: 0.76648*width, y: 0.38837*height))
        path.addLine(to: CGPoint(x: 0.72452*width, y: 0.34785*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.79777*width, y: 0.51021*height))
        path.addLine(to: CGPoint(x: 0.78565*width, y: 0.5099*height))
        path.addCurve(to: CGPoint(x: 0.78498*width, y: 0.53481*height), control1: CGPoint(x: 0.78579*width, y: 0.51821*height), control2: CGPoint(x: 0.78563*width, y: 0.52652*height))
        path.addLine(to: CGPoint(x: 0.79748*width, y: 0.53623*height))
        path.addCurve(to: CGPoint(x: 0.79777*width, y: 0.51021*height), control1: CGPoint(x: 0.79798*width, y: 0.52748*height), control2: CGPoint(x: 0.79804*width, y: 0.51883*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.71229*width, y: 0.69375*height))
        path.addLine(to: CGPoint(x: 0.72442*width, y: 0.70519*height))
        path.addLine(to: CGPoint(x: 0.78173*width, y: 0.56015*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.67281*width, y: 0.72692*height))
        path.addLine(to: CGPoint(x: 0.683*width, y: 0.74092*height))
        path.addCurve(to: CGPoint(x: 0.70433*width, y: 0.72427*height), control1: CGPoint(x: 0.69037*width, y: 0.73577*height), control2: CGPoint(x: 0.69748*width, y: 0.73021*height))
        path.addLine(to: CGPoint(x: 0.69312*width, y: 0.71146*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.51921*width, y: 0.7755*height))
        path.addCurve(to: CGPoint(x: 0.50062*width, y: 0.77492*height), control1: CGPoint(x: 0.51296*width, y: 0.77558*height), control2: CGPoint(x: 0.50679*width, y: 0.77521*height))
        path.addLine(to: CGPoint(x: 0.4995*width, y: 0.798*height))
        path.addCurve(to: CGPoint(x: 0.65948*width, y: 0.75592*height), control1: CGPoint(x: 0.55567*width, y: 0.7979*height), control2: CGPoint(x: 0.61148*width, y: 0.78354*height))
        path.addLine(to: CGPoint(x: 0.65062*width, y: 0.74065*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.44206*width, y: 0.79308*height))
        path.addCurve(to: CGPoint(x: 0.47027*width, y: 0.79675*height), control1: CGPoint(x: 0.45144*width, y: 0.79475*height), control2: CGPoint(x: 0.46083*width, y: 0.79596*height))
        path.addLine(to: CGPoint(x: 0.47398*width, y: 0.7724*height))
        path.addLine(to: CGPoint(x: 0.44206*width, y: 0.79308*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.29579*width, y: 0.67488*height))
        path.addLine(to: CGPoint(x: 0.26733*width, y: 0.69642*height))
        path.addLine(to: CGPoint(x: 0.423*width, y: 0.76056*height))
        path.addCurve(to: CGPoint(x: 0.29579*width, y: 0.67488*height), control1: CGPoint(x: 0.31054*width, y: 0.69158*height), control2: CGPoint(x: 0.30298*width, y: 0.68331*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.26671*width, y: 0.63333*height))
        path.addLine(to: CGPoint(x: 0.23321*width, y: 0.6499*height))
        path.addCurve(to: CGPoint(x: 0.24887*width, y: 0.6736*height), control1: CGPoint(x: 0.23804*width, y: 0.658*height), control2: CGPoint(x: 0.24327*width, y: 0.66594*height))
        path.addLine(to: CGPoint(x: 0.28006*width, y: 0.65444*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.23617*width, y: 0.46417*height))
        path.addLine(to: CGPoint(x: 0.19217*width, y: 0.4564*height))
        path.addLine(to: CGPoint(x: 0.25519*width, y: 0.61052*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.24925*width, y: 0.4154*height))
        path.addLine(to: CGPoint(x: 0.20515*width, y: 0.39877*height))
        path.addCurve(to: CGPoint(x: 0.19729*width, y: 0.42694*height), control1: CGPoint(x: 0.20206*width, y: 0.40808*height), control2: CGPoint(x: 0.19944*width, y: 0.41748*height))
        path.addLine(to: CGPoint(x: 0.24152*width, y: 0.43917*height))
        path.addCurve(to: CGPoint(x: 0.24925*width, y: 0.4154*height), control1: CGPoint(x: 0.24373*width, y: 0.43115*height), control2: CGPoint(x: 0.24631*width, y: 0.42321*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.30852*width, y: 0.32412*height))
        path.addLine(to: CGPoint(x: 0.4315*width, y: 0.20058*height))
        path.addCurve(to: CGPoint(x: 0.23508*width, y: 0.33525*height), control1: CGPoint(x: 0.35129*width, y: 0.22052*height), control2: CGPoint(x: 0.27854*width, y: 0.26613*height))
        path.addLine(to: CGPoint(x: 0.25954*width, y: 0.39196*height))
        path.closeSubpath()
        path.move(to: CGPoint(x: 0.46258*width, y: 0.19423*height))
        path.addLine(to: CGPoint(x: 0.46958*width, y: 0.24706*height))
        path.addLine(to: CGPoint(x: 0.49329*width, y: 0.19048*height))
        path.addCurve(to: CGPoint(x: 0.46258*width, y: 0.19423*height), control1: CGPoint(x: 0.48302*width, y: 0.19127*height), control2: CGPoint(x: 0.47279*width, y: 0.19252*height))
        path.closeSubpath()
        return path
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}

enum GeocacheType: Int {
    case Traditional = 2
    case Multi = 3
    case Virtual = 4
    case Letterbox = 5
    case Event = 6
    case Mystery = 8
    case EarthCache = 137
    case Wherigo = 1858
    func getString() -> String {
        return "\(self)"
    }
    func getIcon() -> (AnyView, Color) {
        switch self {
        case .Traditional:
            return (AnyView(TraditionalCacheShape()), Color(hex: TraditionalCacheShape.color))
        case .Multi:
            return (AnyView(MultiCacheShape()), Color(hex: MultiCacheShape.color))
        case .Virtual:
            return (AnyView(VirtualCacheShape()), Color(hex: VirtualCacheShape.color))
        case .Letterbox:
            return (AnyView(LetterboxHybridShape()), Color(hex: LetterboxHybridShape.color))
        case .Event:
            return (AnyView(EventCacheShape()), Color(hex: EventCacheShape.color))
        case .Mystery:
            return (AnyView(MysteryCacheShape()), Color(hex: MysteryCacheShape.color))
        case .EarthCache:
            return (AnyView(EarthCacheShape()), Color(hex: EarthCacheShape.color))
        case .Wherigo:
            return (AnyView(WherigoShape()), Color(hex: WherigoShape.color))
        }
    }
}

struct GeocacheIcon: View {
    var type: GeocacheType = .Mystery
    var size: CGFloat = 48
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundColor(.white)
            Circle()
                .frame(width: size*40.0/48.0, height: size*40.0/48.0)
                .foregroundColor(type.getIcon().1)
            type.getIcon().0
                .frame(width: size, height: size)
                .foregroundColor(.white)
        }
    }
}

struct TraditionalCache_Previews: PreviewProvider {
    static var previews: some View {
        GeocacheIcon()
            .preferredColorScheme(.light)
            .frame(width: 50, height: 50)
    }
}
