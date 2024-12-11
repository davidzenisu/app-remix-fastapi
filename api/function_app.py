import logging
import azure.functions as func
from swa_api import AsgiFunctionApp
import os
import sys
from main import app
if os.environ.get('WEBSITE_RUN_FROM_PACKAGE') == '1':
    package_path = os.path.abspath(os.path.join(
        os.path.dirname(__file__), 'packages'))
    sys.path.append(package_path)

azureLogger = logging.getLogger('azure')
azureLogger.setLevel(logging.ERROR)

app = AsgiFunctionApp(
    app=app, http_auth_level=func.AuthLevel.ANONYMOUS)