<%@ Page Language="C#" MasterPageFile="~/MasterPages/FormDetail.master" AutoEventWireup="true" ValidateRequest="false" CodeFile="RB301000.aspx.cs" Inherits="Page_RB301000" Title="Untitled Page" %>
<%@ MasterType VirtualPath="~/MasterPages/FormDetail.master" %>

<asp:Content ID="cont1" ContentPlaceHolderID="phDS" Runat="Server">
    <px:PXDataSource ID="ds" runat="server" Visible="True" PrimaryView="Orders" SuspendUnloading="False" TypeName="AcumaticaRB.RapidByte.SalesOrderEntry">
	</px:PXDataSource>
</asp:Content>
<asp:Content ID="cont2" ContentPlaceHolderID="phF" Runat="Server">
    <px:PXFormView ID="form" runat="server" DataSourceID="ds" Style="z-index: 100" 
		Width="100%" DataMember="Orders" TabIndex="6700">
		<Template>
			<px:PXLayoutRule runat="server" StartRow="True" StartColumn="True"/>
		    <px:PXSelector ID="edOrderNbr" runat="server" DataField="OrderNbr">
            </px:PXSelector>
            <px:PXTextEdit ID="edStatus" runat="server" AlreadyLocalized="False" DataField="Status">
            </px:PXTextEdit>
            <px:PXCheckBox ID="edHold" runat="server" AlreadyLocalized="False" DataField="Hold" Text="Hold">
            </px:PXCheckBox>
            <px:PXLayoutRule runat="server" ControlSize="XM" LabelsWidth="S" StartColumn="True">
            </px:PXLayoutRule>
            <px:PXSelector ID="edCustomerID" runat="server" DataField="CustomerID">
            </px:PXSelector>
            <px:PXDateTimeEdit ID="edRequiredDate" runat="server" AlreadyLocalized="False" DataField="RequiredDate" DefaultLocale="">
            </px:PXDateTimeEdit>
            <px:PXDateTimeEdit ID="edShippedDate" runat="server" AlreadyLocalized="False" DataField="ShippedDate" DefaultLocale="" Enabled="False">
            </px:PXDateTimeEdit>
            <px:PXLayoutRule runat="server" ColumnSpan="2">
            </px:PXLayoutRule>
            <px:PXTextEdit ID="edDescription" runat="server" AlreadyLocalized="False" DataField="Description">
            </px:PXTextEdit>
            <px:PXLayoutRule runat="server" ControlSize="XM" LabelsWidth="S" StartColumn="True">
            </px:PXLayoutRule>
            <px:PXNumberEdit ID="edLinesTotal" runat="server" AlreadyLocalized="False" DataField="LinesTotal" Enabled="False">
            </px:PXNumberEdit>
            <px:PXNumberEdit ID="edTaxTotal" runat="server" AlreadyLocalized="False" DataField="TaxTotal" Enabled="False">
            </px:PXNumberEdit>
            <px:PXNumberEdit ID="edOrderTotal" runat="server" AlreadyLocalized="False" DataField="OrderTotal" Enabled="False">
            </px:PXNumberEdit>
		</Template>
	</px:PXFormView>
</asp:Content>
<asp:Content ID="cont3" ContentPlaceHolderID="phG" Runat="Server">
    <px:PXGrid ID="grid" runat="server" DataSourceID="ds" Style="z-index: 100" 
		Width="100%" Height="150px" SkinID="Details" TabIndex="8500" TemporaryFilterCaption="Filter Applied">
		<Levels>
			<px:PXGridLevel DataKeyNames="OrderNbr,ProductID" DataMember="OrderDetails">
			    <Columns>
                    <px:PXGridColumn DataField="ProductID">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="UnitPrice" TextAlign="Right" Width="100px">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="OrderQty" TextAlign="Right" Width="100px">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="StockUnit" Width="80px">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="TaxAmt" TextAlign="Right" Width="100px">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="DiscPct" TextAlign="Right" Width="100px">
                    </px:PXGridColumn>
                    <px:PXGridColumn DataField="LinePrice" TextAlign="Right" Width="100px">
                    </px:PXGridColumn>
                </Columns>
			</px:PXGridLevel>
		</Levels>
		<AutoSize Container="Window" Enabled="True" MinHeight="150" />
	</px:PXGrid>
</asp:Content>
