<%@ Page Language="C#" MasterPageFile="~/MasterPages/FormView.master" AutoEventWireup="true" ValidateRequest="false" CodeFile="RB202000.aspx.cs" Inherits="Page_RB202000" Title="Untitled Page" %>
<%@ MasterType VirtualPath="~/MasterPages/FormView.master" %>

<asp:Content ID="cont1" ContentPlaceHolderID="phDS" Runat="Server">
	<px:PXDataSource ID="ds" runat="server" Visible="True" PrimaryView="Customers" SuspendUnloading="False" TypeName="AcumaticaRB.RapidByte.CustomerMaint">
	</px:PXDataSource>
</asp:Content>
<asp:Content ID="cont2" ContentPlaceHolderID="phF" Runat="Server">
	<px:PXFormView ID="form" runat="server" DataSourceID="ds" Style="z-index: 100" Width="100%" DataMember="Customers" TabIndex="1500">
		<Template>
			<px:PXLayoutRule runat="server" StartRow="True" ControlSize="XM" LabelsWidth="S"/>
		    <px:PXMaskEdit ID="edCustomerCD" runat="server" AlreadyLocalized="False" DataField="CustomerCD" DefaultLocale="">
            </px:PXMaskEdit>
            <px:PXTextEdit ID="edCompanyName" runat="server" AlreadyLocalized="False" DataField="CompanyName" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edContactName" runat="server" AlreadyLocalized="False" DataField="ContactName" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edPhone" runat="server" AlreadyLocalized="False" DataField="Phone" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edFax" runat="server" AlreadyLocalized="False" DataField="Fax" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXLayoutRule runat="server" ControlSize="M" LabelsWidth="S" StartColumn="True">
            </px:PXLayoutRule>
            <px:PXTextEdit ID="edAddress" runat="server" AlreadyLocalized="False" DataField="Address" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edCity" runat="server" AlreadyLocalized="False" DataField="City" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edCountryCD" runat="server" AlreadyLocalized="False" DataField="CountryCD" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edRegion" runat="server" AlreadyLocalized="False" DataField="Region" DefaultLocale="">
            </px:PXTextEdit>
            <px:PXTextEdit ID="edPostalCode" runat="server" AlreadyLocalized="False" DataField="PostalCode" DefaultLocale="">
            </px:PXTextEdit>
		</Template>
		<AutoSize Container="Window" Enabled="True" MinHeight="200" />
	</px:PXFormView>
</asp:Content>
