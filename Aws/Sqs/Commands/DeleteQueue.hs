{-# LANGUAGE RecordWildCards, TypeFamilies, FlexibleInstances, MultiParamTypeClasses, OverloadedStrings, TupleSections #-}

module Aws.Sqs.Commands.DeleteQueue where

import           Aws.Response
import           Aws.Sqs.Error
import           Aws.Sqs.Info
import qualified Aws.Sqs.Model as M
import           Aws.Sqs.Query
import           Aws.Sqs.Response
import           Aws.Signature
import           Aws.Transaction
import           Aws.Xml
import           Control.Applicative
import           Control.Arrow         (second)
import           Control.Monad
import           Data.Enumerator              ((=$))
import           Data.Maybe
import           Data.Time.Format
import           System.Locale
import           Text.XML.Enumerator.Cursor   (($/), ($//), (&/), (&|), ($|))
import qualified Data.Enumerator              as En
import qualified Data.Text                    as T
import qualified Text.XML.Enumerator.Cursor   as Cu
import qualified Text.XML.Enumerator.Parse    as XML
import qualified Text.XML.Enumerator.Resolved as XML
import qualified Network.HTTP.Types    as HTTP
import qualified Data.ByteString.UTF8  as BU
import qualified Data.ByteString.Char8 as B
import Debug.Trace

data DeleteQueue = DeleteQueue{
  dqQueueName :: M.QueueName 
}deriving (Show)

data DeleteQueueResponse = DeleteQueueResponse{
} deriving (Show)


dqParse :: Cu.Cursor -> DeleteQueueResponse
dqParse el = do
  DeleteQueueResponse { }

instance SqsResponseIteratee DeleteQueueResponse where
    sqsResponseIteratee status headers = do doc <- XML.parseBytes XML.decodeEntities =$ XML.fromEvents
                                            let cursor = Cu.fromDocument doc
                                            return $ dqParse cursor                                  
          
instance SignQuery DeleteQueue  where 
    type Info DeleteQueue  = SqsInfo
    signQuery DeleteQueue {..} = sqsSignQuery SqsQuery { 
                                             sqsQuery = [("Action", Just "DeleteQueue"), 
                                                        ("QueueName", Just $ B.pack $ M.printQueue dqQueueName)]}

instance Transaction DeleteQueue (SqsResponse DeleteQueueResponse)


