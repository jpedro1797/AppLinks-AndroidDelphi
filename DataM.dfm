object DM: TDM
  OldCreateOrder = False
  Height = 177
  Width = 262
  object Connection: TFDConnection
    Params.Strings = (
      'Database=C:\Users\Joao Pedro\Desktop\Links 2.0\base\links.db3'
      'DriverID=SQLite')
    LoginPrompt = False
    BeforeConnect = ConnectionBeforeConnect
    Left = 24
    Top = 16
  end
  object qryAux: TFDQuery
    Connection = Connection
    Left = 24
    Top = 64
  end
  object PhysSQLiteDriver: TFDPhysSQLiteDriverLink
    Left = 160
    Top = 16
  end
  object WaitCursor: TFDGUIxWaitCursor
    Provider = 'FMX'
    Left = 160
    Top = 64
  end
end
