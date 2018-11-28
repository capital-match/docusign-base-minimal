{-# LANGUAGE DataKinds         #-}
{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE RecordWildCards   #-}
{-# LANGUAGE TypeFamilies      #-}
{-# LANGUAGE TypeOperators     #-}

{-# OPTIONS_GHC -freduction-depth=0 #-}

module DocuSign.Base where

import DocuSign.Base.ContentTypes
import DocuSign.Base.Types
import Servant.API

import Data.Proxy                     ( Proxy (..) )
import Data.Text                      ( Text )
import Servant.API.Verbs              ( StdMethod (..)
                                      , Verb )
import Servant.Client                 ( ClientM
                                      , client)

type DocuSignAPI
{- documentsGetDocument                                                     -} = "v2" :> "accounts" :> Capture "accountId" Text :> "envelopes" :> Capture "envelopeId" Text :> "documents" :> Capture "documentId" Text :> QueryParam "certificate" Text :> QueryParam "encoding" Text :> QueryParam "encrypt" Text :> QueryParam "language" Text :> QueryParam "recipient_id" Text :> QueryParam "show_changes" Text :> QueryParam "watermark" Text :> Verb 'GET 200 '[PDF] PDF
{- envelopesPostEnvelopes                                                   -} :<|> "v2" :> "accounts" :> Capture "accountId" Text :> "envelopes" :> QueryParam "cdse_mode" Text :> QueryParam "completed_documents_only" Text :> QueryParam "merge_roles_on_draft" Text :> ReqBody '[JSON] EnvelopeDefinition :> Verb 'POST 200 '[JSON] EnvelopeSummary
{- loginInformationGetLoginInformation                                      -} :<|> "v2" :> "login_information" :> QueryParam "api_password" Text :> QueryParam "embed_account_id_guid" Text :> QueryParam "include_account_id_guid" Text :> QueryParam "login_settings" Text :> Verb 'GET 200 '[JSON] Authentication
{- viewsPostEnvelopeRecipientView                                           -} :<|> "v2" :> "accounts" :> Capture "accountId" Text :> "envelopes" :> Capture "envelopeId" Text :> "views" :> "recipient" :> ReqBody '[JSON] RecipientViewRequest :> Verb 'POST 200 '[JSON] EnvelopeViews

data DocuSignClient m = DocuSignClient
  { documentsGetDocument :: Text -> Text -> Text -> Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> m PDF
  , envelopesPostEnvelopes :: Text -> Maybe Text -> Maybe Text -> Maybe Text -> EnvelopeDefinition -> m EnvelopeSummary
  , loginInformationGetLoginInformation :: Maybe Text -> Maybe Text -> Maybe Text -> Maybe Text -> m Authentication
  , viewsPostEnvelopeRecipientView :: Text -> Text -> RecipientViewRequest -> m EnvelopeViews
  }

docuSignClient :: DocuSignClient ClientM
docuSignClient = DocuSignClient {..}
  where
  (      documentsGetDocument
    :<|> envelopesPostEnvelopes
    :<|> loginInformationGetLoginInformation
    :<|> viewsPostEnvelopeRecipientView
    ) = client (Proxy :: Proxy DocuSignAPI)

