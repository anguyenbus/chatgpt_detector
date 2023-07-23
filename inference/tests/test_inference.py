import json

import pytest

from ..inference import app, invocations, ping

app.config['TESTING'] = True


def test_ping():
    """Test the ping function."""
    assert ping() == "Healthy"
