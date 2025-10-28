import 'package:flutter/material.dart';

/// Model representing a financial education lesson
class Lesson {
  final String id;
  final String title;
  final String description;
  final String content;
  final int duration; // in minutes
  final String difficulty; // 'Beginner', 'Intermediate', 'Advanced'
  final IconData icon;
  final Color color;
  final List<QuizQuestion> quizQuestions;
  final String? videoUrl;
  final bool hasCalculator;
  final Map<String, dynamic>? calculatorData;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.duration,
    required this.difficulty,
    required this.icon,
    required this.color,
    required this.quizQuestions,
    this.videoUrl,
    this.hasCalculator = false,
    this.calculatorData,
  });
}

/// Model representing a quiz question
class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;
  final String explanation;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
    required this.explanation,
  });
}

/// Sample lesson data for teens
class LessonData {
  static List<Lesson> getTeenLessons() {
    return [
      // Lesson 1: Budgeting
      Lesson(
        id: 'broke_no_more',
        title: 'Broke No More: Budgeting 101',
        description: 'Stop being cooked by your spending habits',
        content: '''You ever check your bank account and just feel... defeated? Like you just got paid and somehow you're already broke? Yeah, me too.

Here's the thing about budgeting - it's not about restricting yourself from having fun. It's about being smart with your money so you can actually enjoy it without the stress.

Let's talk about where your money actually goes. The average college student spends their money like this:

Gas - "It's not that much" but then you do the math and it's like \$50 a week, which is \$200 a month. That adds up fast.

Food - "I deserve this DoorDash" becomes a daily habit and suddenly you're spending more on delivery apps than you are on groceries.

Subscriptions - Spotify, Netflix, gym membership, Apple Music, Prime, Disney+, three different VPNs you forgot you still had... these small amounts add up to hundreds every month.

Track your spending for one week. I promise you'll be shocked where your money is actually going.

Now let's talk about the 50/30/20 rule. It's a super simple way to break down your money:

Needs (50%): Stuff you literally can't avoid. Rent or dorm fees, gas or car payment, groceries (actual groceries, not DoorDash), utilities. The essentials.

Wants (30%): This is where the fun happens. Coffee runs, clothes that convinced you in the moment, going out with friends, your weird collections. It's okay, we all have them.

Savings (20%): Your future self will absolutely thank you for this.

Here's how the math works. Let's say you make \$800 a month from your part-time gig:

\$400 goes to needs (gas, food basics, dorm stuff)
\$240 goes to wants (fun stuff!)
\$160 goes to savings (your future financial freedom)

But wait, you want that new iPhone that just dropped? That's \$1,000. At \$160 a month saved, that's about 6 months of saving. Is it worth it? That's your call, but at least now you know.

Want something that costs more than \$50? Wait 48 hours. Ask yourself: Will I still want this tomorrow? In a week? Can I afford it without crying? If you answer yes to all three, get it. If not, your future self is already celebrating you saved that money.

And here's a pro tip - use an app like PennyPal to automatically track this stuff. You're too busy to manually enter every single coffee purchase, and technology makes this way easier than it used to be.

Remember, budgeting isn't about never having fun. It's about making sure you can have fun without stressing about money later.''',
        duration: 10,
        difficulty: 'Beginner',
        icon: Icons.wallet,
        color: Colors.green,
        quizQuestions: [
          QuizQuestion(
            question: 'Your friend spends \$300 a month on coffee. If they make \$1,200 a month, what percentage of their income is that?',
            options: ['25%', '30%', '35%', '40%'],
            correctAnswerIndex: 0,
            explanation: 'That\'s a full quarter of their income on coffee. The math is 300 divided by 1200, which equals 0.25, or 25%. Time to invest in a good thermos.',
          ),
          QuizQuestion(
            question: 'What\'s the best use of "wants" money in the 50/30/20 rule?',
            options: [
              'Buying crypto because your friend told you to',
              'Building an emergency fund',
              'Fun stuff that brings you joy and doesn\'t put you in debt',
              'Giving it all to your little sibling'
            ],
            correctAnswerIndex: 2,
            explanation: 'Wants money is literally for enjoying your life. Just make sure you\'re not sacrificing your needs or savings for it. Fun should be sustainable.',
          ),
          QuizQuestion(
            question: 'You want to buy a \$500 item. How much should you have saved before buying it?',
            options: ['Exactly \$500', 'At least \$600', 'Any amount is fine', 'Nothing, use Afterpay'],
            correctAnswerIndex: 1,
            explanation: 'Always have a cushion. Unexpected expenses happen, and paying cash instead of financing keeps you out of debt traps.',
          ),
          QuizQuestion(
            question: 'True or False: Budgeting means you can never buy anything fun.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
            explanation: 'Completely false. Budgeting is about being intentional with your money. You SHOULD have a fun category. You\'re not a robot.',
          ),
        ],
      ),

      // Lesson 2: Credit Scores
      Lesson(
        id: 'credit_score_sneaky',
        title: 'Your Credit Score: Why It Matters',
        description: 'Learn how credit scores work and how to build them',
        content: '''Alright, let's talk about your credit score. That three-digit number between 300 and 850 that's basically your financial reputation score. People are actually checking this thing, so you should know what it is.

Think of it like your follower count, but for creditors instead of social media.

If your score is over 750, you're doing amazing. Banks love you. If it's between 700 and 750, that's solid and stable. If it's under 600, you're in the trenches and it's time to build it back up.

Your credit score determines a lot - whether you can rent an apartment, buy a car, get a loan, or even qualify for utilities. It matters way more than most people think.

Here's how it actually works. Your credit score is based on five things:

Payment History, which is 35% of your score - Do you pay your bills on time? If you miss a payment, your score drops hard. This is the biggest factor.

Amounts Owed, which is 30% - How much of your credit are you using? Keep your usage under 30% of your limit. Using your full credit limit is a red flag to lenders.

Length of Credit History, which is 15% - How long have you been doing this? If you're new to credit, your score starts low. Give it time.

Credit Mix, which is 10% - Different types of credit like cards and loans show variety and responsibility.

New Credit, which is also 10% - Stop applying for 10 cards at once. Every hard inquiry dings your score slightly. Just chill.

Remember that text exchange everyone's had?

You: "Should I get a credit card?"

Mom: "Only if you're responsible."

You: Gets credit card, maxes it out buying concert tickets

Also you: "Wait, why am I being charged interest?"

Credit cards aren't free money. They're a tool to build credit, not destroy it.

Here's how to actually build credit as a teen or young adult:

Before 18, stay out of debt. Practice with a debit card. Learn the basics, which is why you're doing this lesson right now.

After 18, get a student credit card with a LOW limit like \$500. Use it for one small thing like gas or your Spotify subscription. Pay it off EVERY month - set up autopay, don't even think about it. And never spend more than you have. If you don't have the cash in your bank account, you can't afford it.

Treat your credit card like a debit card. If you can't pay it off immediately, don't buy it. That's the golden rule.

Some mistakes that will absolutely destroy your credit score:

Only paying the minimum balance - You're basically paying the bank to hold your money. The interest is wild and it will bury you.

Using 90% or more of your credit limit - This makes you look desperate and financially unstable. Don't do it.

Missing payments - This hits your score hard and stays on your record for years. Set up autopay. No excuses.

Applying for too many cards at once - Eager to build credit? Don't apply to 10 cards in one month. Each application dings your score.

The golden rule is this: Only use credit if you can pay it back IMMEDIATELY. If you don't have cash in your bank account right now, you can't afford it on credit. Period.''',
        duration: 12,
        difficulty: 'Beginner',
        icon: Icons.credit_score,
        color: Colors.blue,
        quizQuestions: [
          QuizQuestion(
            question: 'Your credit card has a \$1,000 limit. How much should you use to keep your score healthy?',
            options: ['\$50', '\$300', '\$900', '\$1,000'],
            correctAnswerIndex: 1,
            explanation: 'Keep credit utilization under 30%. For a \$1,000 limit, that means using \$300 or less. Lenders like to see you\'re not desperate for credit.',
          ),
          QuizQuestion(
            question: 'You just got your first credit card. What should you do first?',
            options: [
              'Buy something expensive to build credit fast',
              'Max it out to show you can handle debt',
              'Make small purchases and pay them off in full every month',
              'Share your account with your bestie'
            ],
            correctAnswerIndex: 2,
            explanation: 'Start small. Use it for regular purchases like gas or streaming subscriptions and pay it off in full every month. This shows you\'re responsible.',
          ),
          QuizQuestion(
            question: 'What happens if you only pay the minimum balance on your credit card?',
            options: [
              'Your credit score skyrockets',
              'You avoid interest charges',
              'You pay tons of interest and your debt spirals',
              'Nothing bad happens'
            ],
            correctAnswerIndex: 2,
            explanation: 'You\'ll be buried in interest. Credit card companies love when you only pay minimums because they make bank off your debt. Always pay in full.',
          ),
          QuizQuestion(
            question: 'True or False: Checking your own credit score hurts it.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
            explanation: 'False. Checking your own score, called a soft inquiry, doesn\'t hurt it. Only when a lender checks your credit, called a hard inquiry, does it slightly drop.',
          ),
        ],
      ),

      // Lesson 3: Investing Basics
      Lesson(
        id: 'dont_let_inflation_cook_you',
        title: 'Don\'t Let Inflation Eat Your Money',
        description: 'Start investing now or watch your money lose value over time',
        content: '''Real talk time: your money in a savings account is losing value. Right now. While you're reading this.

Here's the brutal math they don't tell you in school. Inflation is around 3% per year, but most savings accounts earn maybe 0.01% interest per year. That means you're losing almost 3% of your money's value every single year.

That \$100 you saved? In 10 years, it's worth about \$74 in today's dollars. Yeah, it's that bad.

This is where investing saves you. The stock market, specifically the S&P 500, has averaged about 10% returns per year for the last century.

Want to see the math? If you save \$100 a month in a savings account for 20 years, you'll have \$24,000. But if you invest that same \$100 a month at 7% returns for 20 years, you'll have \$52,000. You literally double your money by investing.

This is why your parents keep telling you to invest. They're not wrong.

So what even is investing? It's basically buying little pieces of companies that hopefully grow in value over time. It's not gambling. It's not day trading. It's buying a small piece of the economy and letting it grow while you sleep.

Warren Buffett made over \$100 billion doing exactly this. You can too, just with smaller numbers.

Here are the basics you need to know:

Stocks are tiny pieces of companies like Apple, Google, or Nike. You can buy individual ones if you like stress.

ETFs, or Exchange-Traded Funds, are baskets of stocks. It's like buying the whole grocery store instead of one apple. More diverse, less risky.

Index Funds are automated ETFs that mirror the market. They're the most boring option, which is why they're the most reliable. This is where you should probably start.

An S&P 500 Index Fund invests in the top 500 companies in America. One fund, instant diversification. This is what everyone recommends for a reason.

Here's what you need to know: Time in the market beats timing the market. The stock market has ups and downs. Since 1950, it's been down for whole years about 25% of the time. But it's always recovered and grown higher.

If you panic-sell when it drops, you lock in losses. If you hold, or better yet buy more when it drops, you win long-term.

How do you actually start without losing your mind?

First, open a brokerage account. Fidelity, Charles Schwab, Vanguard, or Robinhood all work. It takes like 10 minutes online.

Second, set up automatic deposits. Even \$25 a month is fine. Seriously. Make it automatic so you don't have to think about it.

Third, buy an S&P 500 index fund. Look for something like VOO from Vanguard, IVV from iShares, or SPY. They're basically all the same thing. Buy it, hold it, you're done.

Fourth, literally forget about it. Don't check it every day. Don't panic when it drops, because it will drop. Don't sell unless you need the money for something important.

Here's the most important part - the power of starting early. If you start at 18 and invest \$200 a month until 65, you'll have over \$1.2 million, assuming 7% returns. But if you wait until 30 to start, investing that same \$200 a month until 65, you'll only have about \$308,000. You earn four times more by starting just 12 years earlier.

Time is genuinely your best friend when it comes to investing. There's something called the Rule of 72. It tells you how long it takes to double your money. You divide 72 by your return rate. If you're earning 7% returns, you divide 72 by 7 to get about 10 years. That's how long it takes to double your money.

You don't need to be a genius. You don't need \$10,000 to start. You don't need to pick individual stocks.

Just invest in index funds consistently for decades. That's literally it. The boring strategy that actually works.''',
        duration: 15,
        difficulty: 'Intermediate',
        icon: Icons.trending_up,
        color: Colors.purple,
        quizQuestions: [
          QuizQuestion(
            question: 'If you invest \$100 a month at 7% returns for 20 years, approximately how much will you have?',
            options: ['\$20,000', '\$52,000', '\$100,000', '\$250,000'],
            correctAnswerIndex: 1,
            explanation: 'With compound interest, you\'d have about \$52,000. You only contributed \$24,000, but growth and compounding did the rest.',
          ),
          QuizQuestion(
            question: 'What does it mean to invest in the S&P 500?',
            options: [
              'Buying individual stocks from 500 companies',
              'Buying one fund that mirrors the top 500 companies',
              'Gambling on random stocks',
              'Putting all your money in one company'
            ],
            correctAnswerIndex: 1,
            explanation: 'An S&P 500 index fund is like buying the whole grocery store. You get instant diversification across 500 companies, not just one stock.',
          ),
          QuizQuestion(
            question: 'True or False: You should check your investments every day and sell when prices drop.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
            explanation: 'False. Daily checking leads to bad emotional decisions. The market will drop and that\'s normal. Stay calm and hold.',
          ),
          QuizQuestion(
            question: 'The Rule of 72 tells you:',
            options: [
              'How many years until your money doubles',
              'How many stocks to buy',
              'What your credit score should be',
              'How much you should save'
            ],
            correctAnswerIndex: 0,
            explanation: 'Divide 72 by your return rate to see how many years it takes to double your money. At 7% returns, that\'s about 10 years.',
          ),
        ],
      ),

      // Lesson 4: Taxes
      Lesson(
        id: 'where_your_money_goes',
        title: 'Where Your Money Really Goes',
        description: 'Understanding taxes without falling asleep',
        content: '''When you get a paycheck, you're probably not getting paid what you think you are. Taxes take their cut first, and here's what's actually happening.

Let's start with the basics. You probably see two numbers on your paycheck. Gross is the big number that made you excited. Net is the smaller number you actually get.

For example, if you make \$20 an hour working part-time, your gross pay is about \$1,600 a month if you work 40 hours. But after taxes, you'll probably get about \$1,360. That's almost \$250 a month going to taxes.

I know, it hurts. But here's what those taxes actually pay for.

Federal Income Tax covers roads, military, NASA, parks, and all the basic infrastructure. State Income Tax covers your state's budget for education and healthcare. FICA covers Social Security and Medicare, which is basically your future retirement and healthcare.

Fun fact: you're paying into your own Social Security and Medicare. It's basically a forced retirement account that you'll get back eventually.

You have to file taxes every year by April 15th. Mark your calendar. Your future self will thank you for staying on top of this.

But wait, do you even need to file? If you made less than about \$13,850, you probably don't need to file. But you should anyway because you might get refunds or qualify for tax credits.

If you're a dependent, which most teens and college students are, you probably won't pay much or anything in federal taxes. But still file to learn the process.

Students get special treatment with tax credits. If you're in college and paying tuition, you can get up to \$2,500 with the American Opportunity Tax Credit. That's literally free money. There's also the Lifetime Learning Credit which gives you \$2,000 for education expenses.

If your parents are saving for your college, they might be using a 529 Plan, which has tax-free growth for education savings.

Now let's talk about the difference between a W-2 employee and a 1099 contractor.

If you're a W-2 employee, your boss takes out taxes automatically. You get a W-2 form in January showing what they withheld. Easy.

But if you're a 1099 contractor, you work for yourself and you're responsible for all the taxes. This hits different. If you're a contractor, you need to save about 25 to 30% of every payment for taxes, file quarterly estimated taxes, and pay self-employment tax on top of income tax.

Being a contractor at a restaurant sounds fun, but they're not doing you any favors tax-wise. That's lowkey a lot of work.

Here's how tax brackets actually work. You're probably in the lowest bracket, which is 10% or 12% for 2024.

The first \$11,600 you make is taxed at 10%. The next \$35,550 you make is taxed at 12%. And so on.

You're not paying 12% on all your income, just the income in that bracket. This is why making more money won't suddenly put you in a 22% tax bracket and make you lose money overall. That's fake news. Making more money equals more money. Period.

There are apps that make this easier. TurboTax and H&R Block ask you questions and handle the filing, but they cost money. If you made under \$79,000, you can file for free using IRS Free File. Go to IRS.gov/freefile. There's also FreetaxUSA which is actually free and actually works.

Pro tip: Save your W-2s, keep receipts for education expenses, and don't wait until April 14th to start.

There's a difference between deductions and credits that matters a lot.

Deductions reduce your taxable income. So if you deduct \$1,000, you're taxed on less income, which saves you money based on your tax bracket.

Credits reduce your tax bill directly. So if you get a \$1,000 credit, you pay \$1,000 less in taxes. This is better. Credits are better than deductions.

Most students don't itemize deductions. You're probably better off taking the standard deduction, which is about \$14,600 for 2024 if you file single.

Some common tax mistakes to avoid:

Don't forget to file. You'll get penalties. Plus if you're owed a refund and don't file, you only have three years to claim it.

Don't not file just because you "didn't make enough." You might be leaving money on the table. File anyway.

Don't not keep records. Keep your W-2s, 1099s, and receipts for deductions. The IRS can audit you up to three years back.

Don't file late. If you're getting a refund, no big deal. But if you owe money, there are penalties and interest.

Taxes aren't optional. You can't avoid them, but you can understand them and take advantage of deductions and credits. File every year, start early, and learn the process.''',
        duration: 15,
        difficulty: 'Intermediate',
        icon: Icons.receipt_long,
        color: Colors.orange,
        quizQuestions: [
          QuizQuestion(
            question: 'If you make \$2,000 a month working part-time, approximately how much should you expect in taxes?',
            options: ['\$0', 'About \$300', 'About \$600', 'About \$1,000'],
            correctAnswerIndex: 1,
            explanation: 'At about 15% average tax rate including income and FICA, you\'re looking at about \$300 a month in taxes.',
          ),
          QuizQuestion(
            question: 'What\'s the biggest difference between a W-2 employee and a 1099 contractor?',
            options: [
              'W-2 employees make more money',
              'W-2 employees have taxes withheld automatically, while 1099 contractors pay everything themselves',
              '1099 contractors don\'t pay taxes',
              'There\'s no difference'
            ],
            correctAnswerIndex: 1,
            explanation: 'W-2 employees have taxes taken out automatically. 1099 contractors are responsible for all taxes themselves, including quarterly estimated payments.',
          ),
          QuizQuestion(
            question: 'You\'re a college student paying \$5,000 in tuition. What could you claim?',
            options: [
              'Nothing, students don\'t get tax benefits',
              'The American Opportunity Tax Credit, up to \$2,500',
              'A lifetime of regret',
              'Deductions for attending classes'
            ],
            correctAnswerIndex: 1,
            explanation: 'The American Opportunity Tax Credit can save you up to \$2,500 in taxes for education expenses. This is free money for students who qualify.',
          ),
          QuizQuestion(
            question: 'True or False: If you make less than \$13,850, you don\'t need to file taxes.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
            explanation: 'Technically you might not owe taxes, but you should still file because you might get refunds or tax credits. Never leave money on the table.',
          ),
        ],
      ),

      // Lesson 5: Emergency Fund
      Lesson(
        id: 'emergency_fund_vibes',
        title: 'Emergency Fund: Your Financial Safety Net',
        description: 'Build your safety net before life hits you with unexpected expenses',
        content: '''You know what's not fun? Having a flat tire, a medical emergency, or some other unexpected expense that completely drains your bank account.

You know what IS fun? Having money set aside so you can handle life's curveballs without stress. That's what an emergency fund is for. Stop living paycheck to paycheck. Start stacking.

An emergency fund is basically your financial safety net. You want to have three to six months of expenses saved in a separate savings account that you don't touch unless it's actually an emergency.

An emergency is when your car breaks down, a medical bill hits, you lose your job, an actual crisis happens. An emergency is NOT concert tickets dropping, a new iPhone coming out, Black Friday deals, or your friend convincing you to split that expensive dinner.

A good starting point is \$1,000 to \$2,000. Your ultimate goal should be three to six months of expenses.

Let's say your monthly expenses are \$1,200. That covers rent, gas, food, the basics. Your emergency fund goal would be \$1,200 times three, which is \$3,600. That's your goal. Every dollar saved gets you closer.

Fun fact: Most Americans can't cover a \$400 emergency without borrowing money. Don't be most Americans.

Without an emergency fund, you're stuck. Your car breaks down? Credit card debt. Medical emergency? Credit card debt. Lost your job? Credit card debt. See the pattern?

With an emergency fund, you're prepared. Your car breaks down? You got it covered, no stress. Medical emergency? You're covered. Lost your job? You have three to six months to figure it out. Peace of mind is priceless.

You want to keep this in a high-yield savings account, not in your checking account where it's too easy to spend, and not invested in stocks where you can't access it quickly.

Look for a savings account with a good APY, which stands for Annual Percentage Yield. You want something around 4 to 5%. Online banks usually have better rates than traditional banks. Check out banks like Ally, Marcus, or Capital One 360.

Lowkey tip: Keep it in a separate account with a different bank. Out of sight, out of mind. You're less likely to spend it.

Here's how to build it without hating your life:

First, automate it. Set up automatic transfers. \$100 a month is better than nothing. Make it happen every payday.

Second, start small and increase over time. Week one, save \$25. Month two, bump it to \$50. Month three, bump it to \$100. Build the habit, then increase as you can.

Third, use bonuses and tax refunds. Got a tax refund? Put half in your emergency fund. Got a bonus from work? Emergency fund. Birthday money? Emergency fund.

Fourth, cut unnecessary spending temporarily. That extra coffee goes into the emergency fund. That subscription you forgot about, cancel it and put that money in your emergency fund. Skip DoorDash this week and put that money in your emergency fund.

The goal is to push hard for three to six months to build it quickly, then go back to normal. You just need to get this done.

When should you actually use it? Use it for medical emergencies, car repairs if you need your car, job loss, unexpected moves, a broken phone or appliance you need for work, actual emergencies.

Don't use it for planned vacations, new clothes, concert tickets, impulse purchases, splurges, or credit card minimum payments. That's not what it's for.

Once you use it, refill it immediately. This is your lifeline. Don't let it sit empty.

You can even level up and build multiple funds. Your emergency fund for actual emergencies. An unexpected fund for car repairs and medical copays. A sinking fund for planned expenses like vacations or holiday gifts.

Having multiple buckets helps you mentally separate "this is for emergencies only" from "this is for fun things."

Here's a challenge for you. Save your first \$1,000 in 60 days. Then save \$100 a month until you hit three months of expenses. Keep it funded and never let it dip below one month.

Once you have this fund, you'll sleep better. I promise.

Pro tip: Once you hit your goal, you can invest the rest. But keep the emergency fund in a savings account forever. It's insurance.

An emergency fund is not optional. It's the difference between being financially secure and living paycheck to paycheck.

Start today. Even \$25 a week adds up. In a year, that's \$1,300. That's enough to cover most minor emergencies.''',
        duration: 12,
        difficulty: 'Beginner',
        icon: Icons.shield,
        color: Colors.teal,
        quizQuestions: [
          QuizQuestion(
            question: 'How much should you aim to have in your emergency fund?',
            options: [
              '\$500',
              'One month of expenses',
              'Three to six months of expenses',
              'As much as possible, no limit'
            ],
            correctAnswerIndex: 2,
            explanation: 'Three to six months of expenses is the sweet spot. This gives you enough cushion for job loss or major emergencies without being excessive.',
          ),
          QuizQuestion(
            question: 'Where should you keep your emergency fund?',
            options: [
              'Invested in stocks for maximum growth',
              'In your checking account for easy access',
              'In a high-yield savings account separate from your checking account',
              'Under your mattress'
            ],
            correctAnswerIndex: 2,
            explanation: 'High-yield savings account in a separate bank. It earns interest, stays safe, and you won\'t be tempted to spend it.',
          ),
          QuizQuestion(
            question: 'Your car needs \$1,500 in repairs. What should you do?',
            options: [
              'Put it on a credit card and pay later',
              'Skip the repairs until you can afford it',
              'Use your emergency fund if you need your car for work or school',
              'Ask your parents for the money'
            ],
            correctAnswerIndex: 2,
            explanation: 'If your car is essential for work or school and you have an emergency fund, this is what it\'s for. Just make sure to rebuild the fund afterward.',
          ),
          QuizQuestion(
            question: 'True or False: An emergency fund is optional if you have good credit.',
            options: ['True', 'False'],
            correctAnswerIndex: 1,
            explanation: 'False. Credit is debt. An emergency fund is your money. Avoid debt by having cash saved for emergencies.',
          ),
        ],
      ),
    ];
  }
}
