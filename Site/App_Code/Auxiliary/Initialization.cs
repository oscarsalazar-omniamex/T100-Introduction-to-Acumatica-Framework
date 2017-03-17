using PX.Data;
using PX.Data.RelativeDates;

public static class Initialization
{
	public static void ProcessApplication()
	{
		InitReports();
		InitVersion();
		InitPageTitle();
    }

    public static void ProcessRequest()
	{
	}

	public static void ProcessHandler()
	{
		InitExecutionContext();
	}

	private static void InitReports()
	{
		PX.Reports.ReportFileManager.ReportsDir = "~/ReportsDefault";
		PX.Reports.ReportFileManager.CustomReportsDir = "~/ReportsCustomized";
		PX.Reports.CertificateProvider.Register(new PX.Data.Reports.PXCertificateProvider());
		PX.Reports.LocalizationProvider.Register(new PX.Data.Reports.PXReportLocalizationProvider());
		PX.Reports.DbImagesProvider.Register(new PX.Data.Reports.PXDbImagesProvider());
		PX.Reports.SettingsProvider.Register(new PX.Data.Reports.PXSettingProvider());
	}

	private static void InitVersion()
	{
		PX.Common.Service.VersionService.Register(new PX.Data.PXVersionInfo.VersionService());
	}

	private static void InitExecutionContext()
	{
		System.Web.HttpRequest req = System.Web.HttpContext.Current.Request;
		PX.Common.PXExecutionContext.Current.Request =
			new PX.Common.PXExecutionContext.RequestInfo(req.ApplicationPath, req.Url.Authority, req.Url.Scheme);
	}

	private static void InitPageTitle()
	{
		PX.Web.UI.TitleModuleService.Register(new PX.Web.Controls.TitleModules.ReminderTitleModule());
		PX.Web.UI.TitleModuleService.Register(new DashboardPageTitleModule());
	}
}
