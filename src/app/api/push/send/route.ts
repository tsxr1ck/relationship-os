import { NextResponse } from 'next/server';
import { createClient } from '@/lib/supabase/server';
import webpush from 'web-push';
import type { PushSubscription } from '@/lib/supabase/types';

webpush.setVapidDetails(
  process.env.VAPID_SUBJECT || 'mailto:txsr1ck@gmail.com',
  process.env.NEXT_PUBLIC_VAPID_PUBLIC_KEY!,
  process.env.VAPID_PRIVATE_KEY!
);

export async function POST(request: Request) {
  try {
    const supabase = await createClient();

    const {
      data: { user },
    } = await supabase.auth.getUser();

    if (!user) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
    }

    const body = await request.json();
    const { title, body: message, icon, actionUrl, userId, tag } = body;

    if (!title || !message) {
      return NextResponse.json(
        { error: 'title and body are required' },
        { status: 400 }
      );
    }

    let query = supabase
      .from('push_subscriptions')
      .select('*')
      .eq('user_id', user.id);

    if (userId) {
      query = supabase
        .from('push_subscriptions')
        .select('*')
        .eq('user_id', userId);
    }

    const { data: subscriptions, error: fetchError } = await query;

    if (fetchError) {
      console.error('[push/send] Fetch error:', fetchError);
      return NextResponse.json(
        { error: 'Failed to fetch subscriptions' },
        { status: 500 }
      );
    }

    if (!subscriptions || subscriptions.length === 0) {
      return NextResponse.json(
        { error: 'No push subscriptions found' },
        { status: 404 }
      );
    }

    const payload = JSON.stringify({
      title,
      body: message,
      icon: icon || '/icon-192.png',
      badge: '/icon-96.png',
      actionUrl: actionUrl || '/dashboard/notificaciones',
      tag: tag || 'default',
    });

    const results = await Promise.allSettled(
      subscriptions.map(async (sub: PushSubscription) => {
        const pushSub: webpush.PushSubscription = {
          endpoint: sub.endpoint,
          keys: {
            auth: sub.auth,
            p256dh: sub.p256dh,
          },
        };

        await webpush.sendNotification(pushSub, payload);
      })
    );

    const failed = results.filter((r) => r.status === 'rejected');
    const expiredEndpoints: string[] = [];

    failed.forEach((result, index) => {
      if (result.status === 'rejected') {
        const error = result.reason as { statusCode?: number };
        if (error.statusCode === 410 || error.statusCode === 404) {
          expiredEndpoints.push(subscriptions[index].endpoint);
        }
        console.error(
          `[push/send] Failed to send to ${subscriptions[index].endpoint}:`,
          result.reason
        );
      }
    });

    if (expiredEndpoints.length > 0) {
      await supabase
        .from('push_subscriptions')
        .delete()
        .in('endpoint', expiredEndpoints);
    }

    return NextResponse.json({
      success: true,
      sent: results.length - failed.length,
      failed: failed.length,
      cleaned: expiredEndpoints.length,
    });
  } catch (error) {
    console.error('[push/send] Unexpected error:', error);
    return NextResponse.json(
      { error: 'Internal server error' },
      { status: 500 }
    );
  }
}
