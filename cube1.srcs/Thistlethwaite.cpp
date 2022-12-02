// test_mofang.cpp : 此文件包含 "main" 函数。程序执行将在此处开始并结束。
//

//#include "pch.h"
#include <iostream>
#include <string>
#include <vector>
#include <map>
#include <queue>
#include <algorithm>
#include <windows.h>
using namespace std;

//----------------------------------------------------------------------

typedef vector<int> vi;

//----------------------------------------------------------------------

int applicableMoves[] = { 0, 262143, 259263, 74943, 74898 };  //262143=111111111111111111 //259263=111111010010111111 //74943=10010010010111111  // 74898=10010010010010010
// TODO: Encode as strings, e.g. for U use "ABCDABCD"

int affectedCubies[][8] = {
  {  0,  1,  2,  3,  0,  1,  2,  3 },   // U
  {  4,  7,  6,  5,  4,  5,  6,  7 },   // D
  {  0,  9,  4,  8,  0,  3,  5,  4 },   // F
  {  2, 10,  6, 11,  2,  1,  7,  6 },   // B
  {  3, 11,  7,  9,  3,  2,  6,  5 },   // L
  {  1,  8,  5, 10,  1,  0,  4,  7 },   // R
};//12条边
/*
*move=0时，U面顺时针旋转90°move=1时，U面顺时针旋转180°move=2时，U面顺时针旋转270°
*move=3时，D面顺时针旋转90°move=4时，D面顺时针旋转180°move=5时，D面顺时针旋转270°
*move=6时，F面顺时针旋转90°move=7时，F面顺时针旋转180°move=8时，F面顺时针旋转270°
*move=9时，B面顺时针旋转90°move=10时，B面顺时针旋转180°move=11时，B面顺时针旋转270°
*move=12时，L面顺时针旋转90°move=13时，L面顺时针旋转180°move=14时，L面顺时针旋转270°
*move=15时，R面顺时针旋转90°move=16时，R面顺时针旋转180°move=17时，R面顺时针旋转270° */
/************************************************************/
vi applyMove(int move, vi state)
{
	int turns = move % 3 + 1;
	int face = move / 3;
	while (turns--)
	{
		vi oldState = state;
		for (int i = 0; i < 8; i++)
		{
			int isCorner = i > 3;//isCorner值为0,0,0,0,1,1,1,1
			int target = affectedCubies[face][i] + isCorner * 12;
			int killer = affectedCubies[face][(i & 3) == 3 ? i - 3 : i + 1] + isCorner * 12;;//(i&3)值为0,1,2,3,0,1,2,3.
			int orientationDelta = (i < 4) ? (face > 1 && face < 4) : (face < 2) ? 0 : 2 - (i & 1);//方向变量;(i&1)值为0,1,0,1,0,1,0,1
			state[target] = oldState[killer];
			//state[target+20] = (oldState[killer+20] + orientationDelta) % (2 + isCorner);
			state[target + 20] = oldState[killer + 20] + orientationDelta;
			if (!turns)
				state[target + 20] %= 2 + isCorner;//state[target+20]=state[target+20] % (2 + isCorner)
		}
	}
	return state;
}
/************************************************************/
int inverse(int move)//inverse相反倒转
{
	return move + 2 - 2 * (move % 3);
}

//----------------------------------------------------------------------

int phase;

//----------------------------------------------------------------------

vi id(vi state)
{

	//--- Phase 1: Edge orientations.(边缘方向)
	if (phase < 2)
		return vi(state.begin() + 20, state.begin() + 32);

	//-- Phase 2: Corner orientations, E slice edges.（调整好角块朝向，将中间层楞块放到中间层，）
	if (phase < 3)
	{
		vi result(state.begin() + 31, state.begin() + 40);//定义result向量长度为state.begin() + 31，值为state.begin() + 40
		for (int e = 0; e < 12; e++)
			result[0] |= (state[e] / 8) << e;
		return result;
	}

	//--- Phase 3: Edge slices M and S, corner tetrads, overall parity. 边切分M和S，角四等分，总奇偶性。
	if (phase < 4)
	{
		vi result(3);        //定义result向量长度为3
		for (int e = 0; e < 12; e++)
			result[0] |= ((state[e] > 7) ? 2 : (state[e] & 1)) << (2 * e);
		for (int c = 0; c < 8; c++)
			result[1] |= ((state[c + 12] - 12) & 5) << (3 * c);
		for (int i = 12; i < 20; i++)
			for (int j = i + 1; j < 20; j++)
				result[2] ^= state[i] > state[j];//异或
		return result;
	}

	//--- Phase 4: The rest.其余的部分
	return state;
}

//----------------------------------------------------------------------

int main ( ) //argc命令行参数个数，argv命令行变元数组
//int main(vector<string> argv)
{
	//////////////////作用计算时间，自己加的
	
	DWORD t1, t2;
	t1 = GetTickCount();
	///////////////////
	vector<string> argv;

	argv = { "UF","DB","UB","UL","BR","DF","FR","UR","DR","FL","DL","BL",
		"RBU","DBR","UBL","ULF","RFD","UFR","LDF","BDL" };					//乱序的魔方状态表示

	//argv = {"UF","UR","BU","LU","DF","DR","DB","DL","FR","FL","BR","BL",
			//"UFR","BUR","BLU","ULF","DRF","DFL","DLB","DBR"};
	//--- Define the goal.
	//需要自己输入argc 和argv存放打乱的魔方状态

	string goal[] = { "UF", "UR", "UB", "UL", "DF", "DR", "DB", "DL", "FR", "FL", "BR", "BL",
			  "UFR", "URB", "UBL", "ULF", "DRF", "DFL", "DLB", "DBR" };		//还原后正序的魔方状态表示

	//--- Prepare current (start) and goal state. 准备当前(开始)和目标状态。
	vi currentState(40), goalState(40);//前20关于位置后20关于方向
	for (int i = 0; i < 20; i++)
	{
		//--- Goal state.
		goalState[i] = i;
		//--- Current (start) state.
		string cubie = argv[i ];//?
		while ((currentState[i] = find(goal, goal + 20, cubie) - goal) == 20)//find(first,last,val)函数查找该范围内的值，无将返回last
		{
			cubie = cubie.substr(1) + cubie[0];//substr(pos)函数返回一个string返回从第pos位开始后的所有值，
			currentState[i + 20]++;
		}
	}

	//--- Dance the funky Thistlethwaite...
	while (++phase < 5)
	{
		//--- Compute ids for current and goal state, skip phase if equal. 计算当前状态和目标状态的id，如果相等则跳过阶段
		vi currentId = id(currentState), goalId = id(goalState);
		if (currentId == goalId)
			continue;

		//--- Initialize the BFS queue.初始化BFS队列。
		queue<vi> q;//队列queue<vector<int>> q，定义q为int型向量队列
		q.push(currentState);
		q.push(goalState);

		//--- Initialize the BFS tables.初始化BFS表。
		map<vi, vi> predecessor;
		map<vi, int> direction, lastMove;
		direction[currentId] = 1;
		direction[goalId] = 2;

		//--- Dance the funky bidirectional BFS...
		while (1)
		{

			//--- Get state from queue, compute its ID and get its direction.从队列中获取状态，计算其ID并获取其方向。
			vi oldState = q.front();
			q.pop();//出队列
			vi oldId = id(oldState);
			int& oldDir = direction[oldId];

			//--- Apply all applicable moves to it and handle the new state.对其应用所有可应用的移动并处理新状态。
			for (int move = 0; move < 18; move++)
			{
				if (applicableMoves[phase] & (1 << move))
				{

					//--- Apply the move.
					vi newState = applyMove(move, oldState);
					vi newId = id(newState);
					int& newDir = direction[newId];

					//--- Have we seen this state (id) from the other direction already?我们已经从另一个方向看到这个状态(id)了吗?
					//--- I.e. have we found a connection?也就是说，我们找到联系了吗?
					if (newDir  &&  newDir != oldDir)
					{

						//--- Make oldId represent the forwards and newId the backwards search state.Make oldId表示前向搜索状态，newId表示后向搜索状态。
						if (oldDir > 1)
						{
							swap(newId, oldId);
							move = inverse(move);//倒转
						}

						//--- Reconstruct the connecting algorithm.重构连接算法。
						vi algorithm(1, move);//值为"UDFBLR"
						while (oldId != currentId)
						{
							algorithm.insert(algorithm.begin(), lastMove[oldId]);
							oldId = predecessor[oldId];
						}
						while (newId != goalId)
						{
							algorithm.push_back(inverse(lastMove[newId]));
							newId = predecessor[newId];
						}

						//--- Print and apply the algorithm.打印并应用算法。
						for (int i = 0; i < (int)algorithm.size(); i++)
						{
							cout << "UDFBLR"[algorithm[i] / 3] << algorithm[i] % 3 + 1;
							currentState = applyMove(algorithm[i], currentState);

						}

						//--- Jump to the next phase.
						goto nextPhasePlease;
					}

					//--- If we've never seen this state (id) before, visit it.如果我们以前从未见过这种状态(id)，请访问它。
					if (!newDir)
					{
						q.push(newState);
						newDir = oldDir;
						lastMove[newId] = move;
						predecessor[newId] = oldId;
					}
				}
			}
		}
	nextPhasePlease:
		;
	}
	//////////////////////
	t2 = GetTickCount();
	cout << endl << "Use Time:" << (t2 - t1)*1.0 / 1000 << "s";	//屏幕上打印出运行时间
	///////////////////////
}
