# Generated by Django 5.2.1 on 2025-05-14 11:55

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('rides', '0001_initial'),
        ('users', '0001_initial'),
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
    ]

    operations = [
        migrations.AddField(
            model_name='driver',
            name='user',
            field=models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='driver_profile', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='ride',
            name='driver',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, related_name='rides', to='rides.driver'),
        ),
        migrations.AddField(
            model_name='ride',
            name='payment_method',
            field=models.ForeignKey(blank=True, null=True, on_delete=django.db.models.deletion.SET_NULL, to='users.paymentmethod'),
        ),
        migrations.AddField(
            model_name='ride',
            name='user',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='rides', to=settings.AUTH_USER_MODEL),
        ),
        migrations.AddField(
            model_name='ride',
            name='category',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='rides', to='rides.ridecategory'),
        ),
        migrations.AddField(
            model_name='ridelocation',
            name='ride',
            field=models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='location_updates', to='rides.ride'),
        ),
    ]
