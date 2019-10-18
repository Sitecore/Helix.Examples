using Sitecore.Data;

namespace BasicCompany.Feature.BasicContent
{
    public static class Templates
    {
        public static class PromoCard
        {
            public static class Fields
            {
                public static readonly ID Link = new ID("{B788E8BC-E944-4A2B-A4BE-3424643D322B}");
                public static readonly ID Image = new ID("{21249F44-5F0F-4CFA-9474-8D72930D6575}");
                public static readonly ID Headline = new ID("{4F73C02B-93CC-4C96-B9FF-9D0D8E853ED6}");
                public static readonly ID Text = new ID("{13EB8DCA-281D-4E75-B6E1-701CA719BCD1}");
            }
        }

        public static class SectionHeader
        {
            public static class Fields
            {
                public static readonly ID Text = new ID("{59D24D0A-F955-4988-B26F-92039B4DF8BD}");
            }
        }

        public static class HeroBanner
        {
            public static class Fields
            {
                public static readonly ID Title = new ID("{5179186C-B95E-4E97-95AB-7958721A9AEB}");
                public static readonly ID Subtitle = new ID("{89B0A8ED-0EE8-4512-B518-AB2C4C2A0B9E}");
                public static readonly ID Image = new ID("{B5F61442-FF0F-46A5-90A8-D6D387DE24A0}");
            }
        }

        public static class AccordionItem
        {
            public static class Fields
            {
                public static readonly ID Title = new ID("{5718E787-142B-41D9-B5A1-0B18F45B8236}");
                public static readonly ID Content = new ID("{45EFE66E-5AD2-4F1D-BAD5-FDF281688681}");
            }
        }
    }
}